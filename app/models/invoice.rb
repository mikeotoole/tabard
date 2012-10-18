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
# Constants
###
  # This is the minimal charge amount
  MINIMUM_CHARGE_AMOUNT=100
  # How long till we cancel a users subscription for failure to pay.
  SECONDS_OF_FAILED_ATTEMPTS=604800 # Seconds in 7 days.

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
  delegate :user_profile, to: :user
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
  validates_date :period_end_date, on_or_after: :period_start_date, on_or_after_message: 'must be on or after start date'
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
    today = Time.now.end_of_day
    seven_days_ago = today - 7.days
    invoices_to_bill = Invoice.where{(period_end_date <= today) &
                                     (paid_date == nil) &
                                     ((first_failed_attempt_date == nil) | (first_failed_attempt_date > seven_days_ago))}
    invoices_to_bill.each do |invoice|
      Invoice.delay.charge(invoice)
    end
  end

  # This will charge the specified invoice_id
  def self.charge(invoice_id)
    invoice = Invoice.find_by_id(invoice_id)
    invoice.charge_customer if invoice.present?
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
  # Gets the community plan invoice item for a community that is not prorated.
  # If the community does not have one a new one is created with the default plan.
  # [Returns] an invoice item with a plan ALWAYS
  ###
  def plan_invoice_item_for_community(community)
    com_id = community.id
    invoice_item = self.invoice_items.not_prorated.where{(item_type == "CommunityPlan") & (community_id == com_id)}.limit(1).first
    if invoice_item.blank?
      invoice_item = self.invoice_items.new({community: community, item: CommunityPlan.default_plan, quantity: 1}, without_protection: true)
    end
    return invoice_item
  end

  ###
  # Returns all recurring upgrade invoice items for a community.
  # [Returns] invoice items with community upgrades OR empty
  ###
  def recurring_upgrade_invoice_items_for_community(community)
    com_id = community.id
    return self.invoice_items.recurring.where{(item_type != "CommunityPlan") & (community_id == com_id)}
  end

  ###
  # Used to update a community plan/upgrades and set or update the community admin's credit card using Stripe.
  # [Args]
  #   * +invoice_attributes+ An attributes hash for the invoice.
  #   * +stripe_card_token+ A Stripe card token. This is not required if the community admin has a Stripe customer id.
  # [Returns] True if Stripe was updated and the invoice was updated, false otherwise
  ###
  def update_attributes_with_payment(invoice_attributes, stripe_card_token=nil)
    success = false
    self.attributes = invoice_attributes unless invoice_attributes.blank?
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
        if self.period_end_date < Time.now
          # charge customer now.
          success = self.charge_customer(false)
        end
      end
    end
    return success
  end

  ###
  # Used to submit a charge to Stripe with this invoice cost.
  # If the invoice is still open it will first be closed.
  #
  # [Returns] True if the charge was submitted to Stripe, false otherwise
  ###
  def charge_customer(send_fail_email=true)
    success = false
    begin
      if self.user_stripe_customer_token.present?
        if self.total_price_in_cents > MINIMUM_CHARGE_AMOUNT
          begin
            raise ActiveRecord::StaleObjectError if self.processing_payment
            self.update_attributes({processing_payment: true, lock_version: self.lock_version}, without_protection: true)
            charge = Stripe::Charge.create(
              amount: self.total_price_in_cents,
              currency: "usd",
              customer: self.user_stripe_customer_token,
              description: "Charge for invoice id:#{self.id}"
            )
            success = self.mark_paid_and_close(charge.id)
          rescue ActiveRecord::StaleObjectError
            errors.add :base, "Payment is already being processed."
            success = false
          rescue Stripe::CardError => e
            # Mark first failed attempt date.
            self.first_failed_attempt_date = Time.now if self.first_failed_attempt_date.blank?
            # Set boolean on user that payment failed (triggering a flash message for them).
            self.user.mark_as_delinquent_account
            if send_fail_email and (Time.now - self.first_failed_attempt_date) > SECONDS_OF_FAILED_ATTEMPTS
              # If over seven days since first failed attempt cancel users subscription.
              if self.invoice_items.prorated.empty?
                # An invoice with no prorated items will have the plans turned to free and the invoice closed.
                self.invoice_items.select(&:has_community_plan?).each do |ii|
                  ii.item = CommunityPlan.default_plan
                end
                self.save!
                self.mark_paid_and_close
                InvoiceMailer.delay.subscription_canceled(self.id, false)
              else
                # An invoice with prorated items will have the recurring items removed and will stay.
                self.invoice_items.recurring.each do |ii|
                  ii.mark_for_destruction
                end
                self.save!
                InvoiceMailer.delay.subscription_canceled(self.id, true)
              end
            else
              case e.code
                when "incorrect_number", "invalid_number", "invalid_expiry_month", "invalid_expiry_year", "invalid_cvc"
                  InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.invalid.short'), I18n.t('card.errors.invalid.full')) if send_fail_email
                  self.errors[:base] = [I18n.t('card.errors.invalid.full')]

                when "expired_card"
                  InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.expired.short'), I18n.t('card.errors.expired.full')) if send_fail_email
                  self.errors[:base] = [I18n.t('card.errors.expired.full')]

                when "incorrect_cvc"
                  InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.cvc.short'), I18n.t('card.errors.cvc.full')) if send_fail_email
                  self.errors[:base] = [I18n.t('card.errors.cvc.full')]

                when "card_declined"
                  InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.declined.short'), I18n.t('card.errors.declined.full')) if send_fail_email
                  self.errors[:base] = [I18n.t('card.errors.declined.full')]

                when "missing"
                  InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.missing.short'), I18n.t('card.errors.missing.full')) if send_fail_email
                  self.errors[:base] = [I18n.t('card.errors.missing.full')]
                  logger.error "CardError charge_customer: #{e.message}"

                when "processing_error"
                  # ERROR: Log error and retry tomorrow.
                  # Add error to invoice.
                  self.errors[:base] = ["There was an error processing your payment."]
                  logger.error "CardError charge_customer: #{e.message}"

                else
                  # ERROR: This should not happen! Log error.
                  # Add error to invoice.
                  self.errors[:base] = ["There was an error processing your payment."]
                  logger.error "CardError charge_customer: #{e.message}"
              end
            end
            success = false
          rescue Stripe::StripeError => e
            logger.error "StripeError charge_customer: #{e.message}"
            # Add error to invoice.
            self.errors[:base] = ["There was an error processing your payment."]
            success = false
          end
        else
          # Invice cost is less then $1.00. Just mark as paid. Log that this happend for later review.
          logger.error "ERROR charge_customer: Invoice was less then $1: #{self.to_yaml}"
          success = self.mark_paid_and_close
        end
      else
        # ERROR Invoice owner has no payment information.
        logger.error "ERROR charge_customer: Invoice owner had no payment info: #{self.to_yaml}"
        InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.missing.short'), I18n.t('card.errors.missing.full')) if send_fail_email
        self.errors[:base] = [I18n.t('card.errors.missing.full')]
        success = false
      end
    rescue Exception => e
      if e.class == ActiveRecord::StaleObjectError
        throw e
      else
        logger.error "ERROR charge_customer: #{e.message}"
        # Add error to invoice.
        self.errors[:base] = ["There was an error processing your payment."]
        success = false
      end
    end
    self.update_column(:processing_payment, false)
    return success
  end

  # This marks the invoice as paid and close.
  def mark_paid_and_close(charge_id=nil)
    success = self.update_attributes({is_closed: true, paid_date: Time.now, stripe_charge_id: charge_id}, without_protection: true)
    # Set boolean on user that payment failed to false.
    self.user.mark_as_good_standing_account if success
    InvoiceMailer.delay.payment_successful(self.id) if charge_id.present?
    return success
  end

  # Custom helper for views to help users read invoice items that look similar.
  def uniqued_invoice_items
    uniqued_ii = Array.new
    self.invoice_items.order(:start_date).each do |invoice_item|
      match = false
      collision_item = nil
      uniqued_ii.each do |inner_item|
        if invoice_item.item == inner_item.item and invoice_item.start_date == inner_item.start_date and invoice_item.end_date == inner_item.end_date and invoice_item.community == inner_item.community and invoice_item.is_prorated == inner_item.is_prorated and invoice_item.is_recurring == inner_item.is_recurring
          match = true
          collision_item = inner_item
          break
        end
      end
      if match
        uniqued_ii.push InvoiceItem.new({invoice: collision_item.invoice, community: collision_item.community, item: collision_item.item, start_date: collision_item.start_date, end_date: collision_item.end_date, quantity: collision_item.quantity + invoice_item.quantity, is_prorated: collision_item.is_prorated, is_recurring: collision_item.is_recurring}, without_protection: true)
        uniqued_ii.delete collision_item
      else
        uniqued_ii.push invoice_item
      end
    end
    return uniqued_ii
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
      valid_next_invoice_date = self.period_end_date + 1.day
      invoice = self.user.invoices.where{(period_start_date <= valid_next_invoice_date) & (period_end_date >= valid_next_invoice_date)}.limit(1).first
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
      unless ii.marked_for_destruction?
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
#  stripe_charge_id             :string(255)
#  period_start_date            :datetime
#  period_end_date              :datetime
#  paid_date                    :datetime
#  discount_percent_off         :integer          default(0)
#  discount_discription         :string(255)
#  deleted_at                   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  is_closed                    :boolean          default(FALSE)
#  processing_payment           :boolean          default(FALSE)
#  charged_total_price_in_cents :integer
#  first_failed_attempt_date    :datetime
#  lock_version                 :integer          default(0), not null
#

