###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a single invoice used for paid services.
###
class Invoice < ActiveRecord::Base
  include Exceptions
  require 'rest_client'
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # This is the minimal charge amount
  MINIMUM_CHARGE_AMOUNT=100
  # If the charged amount is larger then this it is logged (will trigger alert email).
  NOTIFY_CHARGE_AMOUNT=2000
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
  scope :paid, where{(paid_date != nil)}
  scope :tax_overridden, paid.where(tax_error_occurred: true)

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
  validates :charged_state_tax_rate, numericality: { greater_than_or_equal_to: 0, only_integer: false}
  validates :charged_local_tax_rate, numericality: { greater_than_or_equal_to: 0, only_integer: false}

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
    today = Time.zone.now.end_of_day
    seven_days_ago = today - SECONDS_OF_FAILED_ATTEMPTS.seconds
    invoices_to_bill = Invoice.where{(period_end_date <= today) &
                                     (paid_date == nil) & # TODO: Why can't this just look for invoices not closed?
                                     ((first_failed_attempt_date == nil) | (first_failed_attempt_date > seven_days_ago))}
    invoices_to_bill.each do |invoice|
      Invoice.delay.charge(invoice.id)
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
  # This gets the non exempt price in cents
  def non_exempt_total_price_in_cents_without_tax
    invoice_items.empty? ? 0 : invoice_items.map{|ii| ii.non_exempt_total_price_in_cents}.inject(0,:+)
  end

  # This gets the non exempt price in dollars
  def non_exempt_total_price_in_dollars_without_tax
    self.non_exempt_total_price_in_cents_without_tax/100.0
  end

  ###
  # Gets the total non exempt price per month in cents for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def non_exempt_total_recurring_price_per_month_in_cents(community=nil)
    price = 0
    if community.blank?
      invoice_items = self.invoice_items.recurring
    else
      invoice_items = self.invoice_items.recurring.where(community_id: community.id)
    end
    price = invoice_items.map{|ii| ii.non_exempt_total_price_in_cents}.inject(0,:+) unless invoice_items.empty?
    return price
  end

  ###
  # Gets the total non exempt price per month in dollars for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def non_exempt_total_recurring_price_per_month_in_dollars(community=nil)
    self.non_exempt_total_recurring_price_per_month_in_cents(community)/100.0
  end


  # [Returns] the total cost of all invoice items in cents.
  def total_price_in_cents
    if charged_total_price_in_cents.present?
      return charged_total_price_in_cents
    else
      return (self.total_price_in_cents_without_tax + self.total_tax_in_cents)
    end
  end

  # [Returns] the total cost of all invoice items in dollars.
  def total_price_in_dollars
    self.total_price_in_cents/100.0
  end

  def total_price_in_cents_without_tax
    invoice_items.empty? ? 0 : invoice_items.map{|ii| ii.total_price_in_cents}.inject(0,:+)
  end

  def total_price_in_dollars_without_tax
    self.total_price_in_cents_without_tax/100.0
  end

  def total_tax_in_cents
    tax = (self.total_price_in_cents_without_tax * self.tax_rate).round(0)
  end

  def total_tax_in_dollars
    self.total_tax_in_cents/100.0
  end

  def should_be_taxed?
    @should_be_taxed ||= self.tax_rate != 0
    return @should_be_taxed
  end

  def tax_rate
    # If invoice was paid return saved values.
    return self.charged_state_tax_rate + self.charged_local_tax_rate if self.paid_date
    # If tax rate is cached return cached value.
    return @tax_rate if @tax_rate
    # If user has no stripe token then we can't look up tax info. Just return zero.
    if self.user_stripe_customer_token.blank?
      @tax_rate ||= 0.0
    else
      success = false
      user_address = ""
      user_city = ""
      user_zipcode = ""
      begin
        stripe_customer = Stripe::Customer.retrieve(user_stripe_customer_token)
        unless stripe_customer["active_card"].blank?
          user_address = stripe_customer["active_card"]["address_line1"]
          user_city = stripe_customer["active_card"]["address_city"]
          user_zipcode = stripe_customer["active_card"]["address_zip"]
        end
        unless user_address.blank? or user_city.blank? or user_zipcode.blank?
          begin
            response = RestClient.get "http://dor.wa.gov/AddressRates.aspx?output=xml&addr=#{CGI::escape(user_address)}&city=#{CGI::escape(user_city)}&zip=#{CGI::escape(user_zipcode)}"
            kickback_hash = Hash.from_xml(response.to_str)
            case kickback_hash["response"]["code"]
            when "0","1","2"
              rate_info = kickback_hash["response"]["rate"].last
              unless rate_info["code"].blank? or rate_info["staterate"].blank? or rate_info["localrate"].blank?
                self.update_column(:charged_state_tax_rate, rate_info["staterate"]) if self.persisted?
                self.update_column(:charged_local_tax_rate, rate_info["localrate"]) if self.persisted?
                self.update_column(:local_tax_code, rate_info["code"]) if self.persisted?
                success = true
              end
            when "3"
              # The address, ZIP+4, and ZIP could not be  found.
              success = false
            else
              logger.error "ALERT_ERROR model=invoice method=tax_rate wa_error=unexpected_code response_code=#{kickback_hash['response']['code']}"
              self.update_column(:tax_error_occurred, true) if self.persisted?
            end
          rescue => e
            logger.error "ALERT_ERROR model=invoice method=tax_rate request_error=#{e.class} message=#{e.message}"
            self.update_column(:tax_error_occurred, true) if self.persisted?
          end
        end
      rescue => e
        logger.error "ALERT_ERROR model=invoice method=tax_rate stripe_error=#{e.class} message=#{e.message}"
        self.update_column(:tax_error_occurred, true) if self.persisted?
      end
      if success
        @tax_rate ||= (self.charged_state_tax_rate + self.charged_local_tax_rate).round(5)
        self.update_column(:tax_error_occurred, false) if self.persisted?
      else
        @tax_rate ||= 0.0
      end
    end
    return @tax_rate
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
      invoice_item = self.invoice_items.new({community: community, item: CommunityPlan.default_plan, quantity: 1})
    end
    return invoice_item
  end

  def is_downgrading?(community)
    return (self.plan_invoice_item_for_community(community).item.is_free_plan? and not community.current_community_plan.is_free_plan?)
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
    # If no stripe info error
    if self.user_stripe_customer_token.blank? and stripe_card_token.blank?
      #ERROR: Need payment info.
      self.errors.add :base, "Payment information is required"
    else
      if self.valid?
        success = stripe_card_token.present? ? self.user.update_stripe(stripe_card_token) : true
        if success
          success = self.save
        else
          self.errors.add :base, "There was a problem with your credit card. Insure your full billing address is provided."
        end
        if success and self.period_end_date < Time.now
          # Charge customer now not sending email and override tax (eat tax if we can't findout tax info).
          success = self.charge_customer(false, true)
        end
      end
    end
    return success
  end

  ###
  # Used to submit a charge to Stripe with this invoice cost.
  # If the invoice is still open it will first be closed.
  #   * +send_fail_email+ If it should send payment failed email. This is false when a user directly causing charge_customer to be called and will be notified now.
  #   * +override_tax+ If it should ignore tax and flag invoice if we can't find out tax info.
  # [Returns] True if the charge was submitted to Stripe, false otherwise
  ###
  def charge_customer(send_fail_email=true, override_tax=false)
    success = false
    # TODO: look at charge exempt status and how it works with this. -MO
    begin
      if self.user_stripe_customer_token.present?
        if self.total_price_in_cents > MINIMUM_CHARGE_AMOUNT
          if self.tax_error_occurred and not override_tax
            success = false
          else
            raise ActiveRecord::StaleObjectError.new(self, :charge_customer) if self.processing_payment
            self.update_attributes({processing_payment: true, lock_version: self.lock_version}, without_protection: true)
            charge = Stripe::Charge.create( amount: self.total_price_in_cents,
                                            currency: "usd",
                                            customer: self.user_stripe_customer_token,
                                            description: "Charge for invoice id:#{self.id}" )
            # Log big charge
            if self.total_price_in_cents > NOTIFY_CHARGE_AMOUNT
              logger.warn "ALERT_ERROR model=invoice method=charge_customer error=large_charge invoice_id=#{self.id} price=#{self.total_price_in_cents}"
            end
            success = self.mark_paid_and_close(charge.id)
          end
        else
          # Invice cost is less then MINIMUM_CHARGE_AMOUNT. Just mark as paid. Log that this happend for later review.
          logger.warn "ALERT_ERROR model=invoice method=charge_customer error=small_invoice_total invoice_id=#{self.id} price=#{self.total_price_in_cents}"
          success = self.mark_paid_and_close
        end
      else
        # ERROR Invoice owner has no payment information.
        logger.error "ALERT_ERROR model=invoice method=charge_customer error=no_payment_info invoice_id=#{self.id} user_id=#{self.user_id}"
        InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.missing.short'), I18n.t('card.errors.missing.full')) if send_fail_email
        self.errors.add :base, I18n.t('card.errors.missing.full')
        success = false
      end
    rescue Stripe::CardError => e
      # Mark first failed attempt date.
      self.update_column(:first_failed_attempt_date, Time.now) if self.first_failed_attempt_date.blank?
      # Set boolean on user that payment failed (triggering a flash message for them).
      self.user.mark_as_delinquent_account
      # If over seven days since first failed attempt cancel users subscription.
      if send_fail_email and (Time.now - self.first_failed_attempt_date) > SECONDS_OF_FAILED_ATTEMPTS
        self.cancel_subscription
      else
        # If send_fail_email is true and first_failed_attempt_date is today then send email.
        # This is to make sure the user only gets one email about the error.
        send_email = send_fail_email and (self.first_failed_attempt_date < Time.now + 20.hours)
        case e.code
          when "incorrect_number", "invalid_number", "invalid_expiry_month", "invalid_expiry_year", "invalid_cvc"
            InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.invalid.short'), I18n.t('card.errors.invalid.full')) if send_email
            self.errors.add :base, I18n.t('card.errors.invalid.full')

          when "expired_card"
            InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.expired.short'), I18n.t('card.errors.expired.full')) if send_email
            self.errors.add :base, I18n.t('card.errors.expired.full')

          when "incorrect_cvc"
            InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.cvc.short'), I18n.t('card.errors.cvc.full')) if send_email
            self.errors.add :base, I18n.t('card.errors.cvc.full')

          when "card_declined"
            InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.declined.short'), I18n.t('card.errors.declined.full')) if send_email
            self.errors.add :base, I18n.t('card.errors.declined.full')

          when "missing"
            InvoiceMailer.delay.payment_failed(self.id, I18n.t('card.errors.missing.short'), I18n.t('card.errors.missing.full')) if send_email
            self.errors.add :base, I18n.t('card.errors.missing.full')
            logger.error "ALERT_ERROR model=invoice method=charge_customer invoice_id=#{self.id} exception=CardError message=#{e.message} code=#{e.code}"
          when "processing_error"
            # ERROR: Log error and retry tomorrow.
            # Add error to invoice.
            self.errors.add :base, "There was an error processing your payment."
            logger.error "ALERT_ERROR model=invoice method=charge_customer invoice_id=#{self.id} exception=CardError message=#{e.message} code=#{e.code}"
          else
            # ERROR: This should not happen! Log error.
            # Add error to invoice.
            self.errors.add :base, "There was an error processing your payment."
            logger.error "ALERT_ERROR model=invoice method=charge_customer invoice_id=#{self.id} exception=CardError message=#{e.message} code=#{e.code}"
        end
      end
      success = false
    rescue Stripe::StripeError => e
      logger.error "ALERT_ERROR model=invoice method=charge_customer invoice_id=#{self.id} exception=StripeError message=#{e.message}"
      # Add error to invoice.
      self.errors.add :base, "There was an error processing your payment."
      success = false
    rescue ActiveRecord::StaleObjectError => e
      self.errors.add :base, "Payment is already being processed."
      success = false
      raise e
    rescue Exception => e
      logger.error "ALERT_ERROR model=invoice method=charge_customer error=unexpected_exception invoice_id=#{self.id} exception=#{e.class} message=#{e.message}"
      # Add error to invoice.
      self.errors.add :base, "There was an error processing your payment."
      success = false
    end
    self.update_column(:processing_payment, false)
    return success
  end

  ###
  # This will cancel a subscription. If the user has no prorated invoice items all plan invoice items will be turned into free plans.
  # If the user has prorated items all recurring items will be removed.
  # In both cases the user will be notiffide that their subscription was canceled if send_email is true.
  # [Args]
  #   * +send_fail_email+ If it should send payment failed email. This is false when a user directly causing charge_customer to be called and will be notified now.
  # [Returns] True
  ###
  def cancel_subscription(send_email=true)
    if self.invoice_items.prorated.empty?
      # An invoice with no prorated items will have the plans turned to free and the invoice closed.
      self.invoice_items.select(&:has_community_plan?).each do |ii|
        ii.item = CommunityPlan.default_plan
      end
      self.save!
      if self.total_price_in_cents > 0
        logger.error "ALERT_ERROR model=invoice method=cancel_subscription error=canceled_with_balance invoice_id=#{self.id} balance=#{self.total_price_in_cents}"
      end
      self.mark_paid_and_close
      InvoiceMailer.delay.subscription_canceled(self.id, false) if send_email
    # An invoice with prorated items will have the recurring items removed and will stay.
    else
      self.invoice_items.each do |ii|
        ii.mark_for_destruction if ii.is_recurring
      end
      self.save!
      InvoiceMailer.delay.subscription_canceled(self.id, true) if send_email
    end
    return true
  end

  ###
  # This marks the invoice as paid and close.
  #   * +charge_id+ The Stripe Charge ID. Defaults to nil.
  # [Returns] True if success otherwise returns false.
  ###
  def mark_paid_and_close(charge_id=nil)
    success = self.update_attributes({is_closed: true, paid_date: Time.now, stripe_charge_id: charge_id}, without_protection: true)
    unless success
      logger.error "ALERT_ERROR BAD model=invoice method=mark_paid_and_close error=mark_closed_failed invoice_id=#{self.id} time=#{Time.now} charge_id=#{charge_id}"
    end
    if self.tax_error_occurred
      logger.warn "ALERT_ERROR model=invoice method=mark_paid_and_close error=tax_error_occurred invoice_id=#{self.id}"
    end
    self.invoice_items.each do |item|
      item.set_charge_exempt_info
    end
    # Set boolean on user that payment failed to false.
    self.user.mark_as_good_standing_account
    InvoiceMailer.delay.payment_successful(self.id) if charge_id.present?
    return true
  end

  # Custom helper for views to help users read invoice items that look similar.
  def uniqued_invoice_items
    uniqued_ii = Array.new
    self.invoice_items.order(:start_date).each do |invoice_item|
      match = false
      collision_item = nil
      uniqued_ii.each do |inner_item|
        if invoice_item.item == inner_item.item and invoice_item.start_date == inner_item.start_date and invoice_item.end_date == inner_item.end_date and invoice_item.community_id == inner_item.community_id and invoice_item.is_prorated == inner_item.is_prorated and invoice_item.is_recurring == inner_item.is_recurring
          match = true
          collision_item = inner_item
          break
        end
      end
      if match
        # FIXME: I don't like this phantom invoice item. What if the invoice item gets saved? -MO
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
          invoice.invoice_items.new({community: ii.community, item: ii.item, quantity: ii.quantity})
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
#  charged_state_tax_rate       :float            default(0.0)
#  charged_local_tax_rate       :float            default(0.0)
#  local_tax_code               :string(255)
#  disputed_date                :datetime
#  refunded_date                :datetime
#  refunded_price_in_cents      :integer
#  tax_error_occurred           :boolean          default(FALSE)
#

