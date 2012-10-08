###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a single invoice used for paid services.
###
class Invoice < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  attr_accessible :invoice_items_attributes

###
# Associations
###
  belongs_to :user
  has_many :invoice_items, dependent: :destroy, inverse_of: :invoice
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

###
# Delegates
###
  delegate :id, to: :user, prefix: true
  delegate :stripe_customer_token, to: :user, prefix: true

###
# Scopes
###
  scope :closed, where{(is_closed == true)}.order(:period_end_date).reverse_order
  scope :historical, order(:period_end_date).order(:period_start_date).reverse_order

###
# Validators
###
  validates :user, presence: true
  validates :period_start_date, presence: true
  validates :period_end_date, presence: true
  validate :invoice_items_are_valid
  validates_date :period_end_date, on_or_after: :period_start_date, on_or_after_message: 'must be after start date'
  validate :no_reopening_closed_invoice
  validate :cant_be_edited_after_closed

###
# Callbacks
###
  before_save :set_charged_total_price_in_cents_when_closed
  after_save :create_next_invoice_when_closed
  after_save :add_prorated_items

###
# Class Methods
###
  # This will call charge_customer on all invoices that have an end_date before today.
  def self.bill_customers
    invoices_to_bill = Invoice.where{(period_end_date <= Time.now.end_of_day) & (processing_payment == false)}
    invoices_to_bill.each do |invoice|
      invoice.charge_customer
    end
  end

###
# Instance Methods
###
  # [Returns] the total cost of all invoice items in cents.
  def total_price_in_cents
    if charged_total_price_in_cents.present?
      self.charged_total_price_in_cents
    else
      invoice_items.empty? ? 0 : invoice_items.map{|ii| ii.total_price_in_cents}.inject(0,:+)
    end
  end

  # [Returns] the total cost of all invoice items in dollars.
  def total_price_in_dollars
    self.total_price_in_cents/100.0
  end

  ###
  # Gets the total price per month in cents for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def total_recurring_price_per_month_in_cents(community=nil)
    price = 0
    if community.blank?
      invoice_items = self.invoice_items.recurring
    else
      invoice_items = self.invoice_items.recurring.where(community_id: community.id)
    end
    price = invoice_items.map{|ii| ii.total_price_in_cents}.inject(0,:+) unless invoice_items.empty?
    return price
  end

  ###
  # Gets the total price per month in dollars for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def total_recurring_price_per_month_in_dollars(community=nil)
    self.total_recurring_price_per_month_in_cents(community)/100.0
  end

  ###
  # Gets the total price per month in cents for all recurring plans and upgrades.
  # This will include unsaved invoice items.
  ###
  def new_total_recurring_price_per_month_in_cents
    price = 0
    recurring_invoice_items = self.invoice_items.select(&:is_recurring)
    recurring_invoice_items.each do |invoice_item|
      price = price + (invoice_item.total_price_in_cents)
    end
    return price
  end

  ###
  # Gets the total price per month in dollars for all recurring plans and upgrades.
  # This will include unsaved invoice items.
  ###
  def new_total_recurring_price_per_month_in_dollars
    self.new_total_recurring_price_per_month_in_cents/100.0
  end

  ###
  # Returns all recurring plan invoice items for a community.
  # If the community does not have one a new one is created with the default plan.
  ###
  def recurring_plan_invoice_item_for_community(community)
    com_id = community.id
    invoice_item = self.invoice_items.not_prorated.where{(item_type == "CommunityPlan") & (community_id == com_id)}.limit(1).first
    if invoice_item.blank?
      invoice_item = self.invoice_items.new({community: community, item: CommunityPlan.default_plan, quantity: 1}, without_protection: true)
    end
    return invoice_item
  end

  # Returns all recurring upgrade invoice items for a community.
  def recurring_upgrade_invoice_items_for_community(community)
    com_id = community.id
    return self.invoice_items.recurring.where{(item_type != "CommunityPlan") & (community_id == com_id)}
  end

  ###
  # Used to update a community plan/upgrades and bill the community admin using Stripe.
  # [Args]
  #   * +invoice_attributes+ An attributes hash for the invoice.
  #   * +stripe_card_token+ A Stripe card token. This is not required if the community admin has a Stripe customer id.
  # [Returns] True if the Stripe was updated and the invoice was updated, false otherwise
  ###
  def update_attributes_with_payment(invoice_attributes, stripe_card_token)
    success = false
    self.attributes = invoice_attributes
    if self.user_stripe_customer_token.blank? and stripe_card_token.blank?
      #ERROR: Need payment info.
      self.errors.add :base, "Payment information is required"
    else
      if self.valid?
        success = stripe_card_token.present? ? self.user.update_stripe(stripe_card_token) : true
        if success
          success = self.save
        else
          self.errors.add :base, "There was a problem with your credit card"
        end
      end
    end
    return success
  end

  ###
  # Used to submit a charge to Stripe with this invoice cost.
  # If the invoice is still it will first be closed.
  #
  # [Returns] True if the charge was submitted to Stripe, false otherwise
  ###
  def charge_customer
    success = false
    begin
      self.update_attributes({is_closed: true}, without_protection: true) unless self.is_closed
      if self.is_closed
        if self.user_stripe_customer_token.present?
          if self.total_price_in_cents > 100
            begin
              Stripe::Charge.create(
                amount: self.total_price_in_cents,
                currency: "usd",
                customer: self.user_stripe_customer_token,
                description: "Charge for invoice id:#{self.id}"
              )
              success = self.update_attributes({processing_payment: true}, without_protection: true)
            rescue Stripe::StripeError => e
              logger.error "StripeError charge_customer: #{e.message}"
              success = false
            end
          else
            #Invice cost is less then $1.00. Just mark as paid. Log that this happend for later review.
            logger.error "ERROR charge_customer: Invoice was less then $1: #{self.to_yaml}"
            success = self.update_attributes({processing_payment: true, paid_date: Time.now}, without_protection: true)
          end
        else
          #ERROR Invoice owner has no payment information.
          logger.error "ERROR charge_customer: Invoice owner had no payment info: #{self.to_yaml}"
          success = false
        end
      else
        #ERROR Could not close invoice.
        logger.error "ERROR charge_customer: Could not close invoice: #{self.to_yaml} errors: #{self.errors}"
        success = false
      end
    rescue Exception => e
      logger.error "ERROR charge_customer: #{e.message}"
      success = false
    end
    return success
  end

###
# Protected Methods
###
protected

###
# Validator Mathods
###
  ###
  # _Validator_
  #
  # Once an invoice is closed it can't be reopend.
  ###
  def no_reopening_closed_invoice
    if not is_closed and is_closed_was
      self.errors.add(:base, "A closed invoice can't be reopened.")
    end
  end

  ###
  # _Validator_
  #
  # Once an invoice is closed it can't be edited.
  ###
  def cant_be_edited_after_closed
    if is_closed and is_closed_was
      self.errors.add(:base, "A closed invoice can't be edited.")
    end
  end

  ###
  # _Validator_
  #
  # Validates all invoice items.
  ###
  def invoice_items_are_valid
    no_failures = true
    self.invoice_items.each do |invoice_item|
      no_failures = false unless invoice_item.valid?
    end
    self.errors.add(:base, "an invoice item has an error") unless no_failures
  end

###
# Callback Methods
###
  ###
  # _before_save_
  #
  # If this invoice was just closed the calculated price from invoice items will be used to save the price charged.
  ###
  def set_charged_total_price_in_cents_when_closed
    if is_closed and not is_closed_was
      self.charged_total_price_in_cents = self.total_price_in_cents
    end
    return true
  end

  ###
  # _after_save_
  #
  # If this invoice was just closed it will create the next invoice if it does not exist.
  ###
  def create_next_invoice_when_closed
    if is_closed and not is_closed_was
      today = Time.now
      invoice = self.user.invoices.where{(period_start_date <= today) & (period_end_date >= today)}.limit(1).first
      if invoice.blank? and self.invoice_items.recurring.any?
        invoice = self.user.invoices.new
        invoice.period_start_date = self.period_end_date
        invoice.period_end_date = self.period_end_date + 30.days
        self.invoice_items.recurring.each do |ii|
          invoice.invoice_items.new({community: ii.community, item: ii.item, quantity: ii.quantity}, without_protection: true)
        end
        invoice.save!
      end
    end
    return true
  end

  ###
  # _after_save_
  #
  # This will determine if any prorated invoice items should be added to the invoice.
  ###
  def add_prorated_items
    self.invoice_items.select(&:is_recurring).each do |ii|
      today = Time.now
      unless (ii.start_date <= today and ii.end_date >= today)
        com_id = ii.community_id
        type = ii.item_type
        invoice_items = InvoiceItem.where{(community_id == com_id) & (item_type == type) & (start_date <= today) & (end_date >= today)}
        if invoice_items.empty?
          new_ii = self.invoice_items.new(community: ii.community, quantity: ii.quantity, item: ii.item)
          new_ii.is_recurring = false
          new_ii.is_prorated = true
          new_ii.save!
        elsif ii.has_community_upgrade?
          # Add prorated item for upgrade. This looks at the quantites of this ii and the existing ones.
          total_quantity = invoice_items.map(&:quantity).inject(0,:+)
          number_added = ii.quantity - total_quantity
          if number_added > 0
            new_ii = self.invoice_items.new(community: ii.community, quantity: number_added, item: ii.item)
            new_ii.is_recurring = false
            new_ii.is_prorated = true
            new_ii.save!
          end
        end
      end
    end
    return true
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  stripe_invoice_id            :string(255)
#  period_start_date            :datetime
#  period_end_date              :datetime
#  paid_date                    :datetime
#  stripe_customer_id           :string(255)
#  discount_percent_off         :integer
#  discount_discription         :string(255)
#  deleted_at                   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  is_closed                    :boolean          default(FALSE)
#  processing_payment           :boolean          default(FALSE)
#  charged_total_price_in_cents :integer
#

