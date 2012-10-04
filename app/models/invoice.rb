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

###
# Delegates
###
  delegate :id, to: :user, prefix: true
  delegate :stripe_customer_token, to: :user, prefix: true
  delegate :previous_invoice, to: :user, allow_nil: true

###
# Scopes
###
  scope :closed, where{(is_closed == true)}.order(:period_end_date).reverse_order

###
# Validators
###
  validates :user, presence: true
  validates :period_start_date, presence: true
  validates :period_end_date, presence: true
#   validate :invoice_items_are_valid
  validates_date :period_start_date, on_or_after: :today, on: :create
  validates_date :period_end_date, on_or_after: :period_start_date, on: :create
  accepts_nested_attributes_for :invoice_items, allow_destroy: true
  validate :no_reopening_closed_invoice
#   validate :only_one_community_plan_item_per_period


###
# Callbacks
###
  after_save :create_next_invoice_when_closed

###
# Instance Methods
###

  def total_price_in_cents
    invoice_items.empty? ? 0 : invoice_items.map{|ii| ii.total_price_in_cents}.inject(0,:+)
  end

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
    invoice_item = self.invoice_items.recurring.where{(item_type == "CommunityPlan") & (community_id == com_id)}.limit(1).first
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
  # [Returns] True if the Stripe subscription was updated and the invoice was updated, false otherwise
  ###
  def update_attributes_with_payment(invoice_attributes, stripe_card_token)
    if stripe_card_token.blank? and self.user_stripe_customer_token.blank?
      self.errors.add :base, "Payment information is required"
      return false
    else
      self.attributes = invoice_attributes
      if self.valid?
        if self.user.update_stripe(stripe_card_token, self)
          return self.save!
        else
          self.errors.add :base, "There was a problem with your credit card"
          return false
        end
      else
        return false
      end
    end
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
  # COMMENTED OUT
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
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  stripe_invoice_id    :string(255)
#  period_start_date    :datetime
#  period_end_date      :datetime
#  paid_date            :datetime
#  stripe_customer_id   :string(255)
#  discount_percent_off :integer
#  discount_discription :string(255)
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_closed            :boolean          default(FALSE)
#

