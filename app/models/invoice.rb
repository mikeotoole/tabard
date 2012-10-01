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
  delegate :stripe_customer_token, to: :user, prefix: true

###
# Validators
###
  validates :user, presence: true
  validates :period_start_date, presence: true
  validates :period_end_date, presence: true
  validates_date :period_start_date, on_or_after: :today, on: :create
  validates_date :period_end_date, on_or_after: :period_start_date, on: :create
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  ###
  # Gets the total price per month in cents for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def total_price_per_month_in_cents_for_community(community)
    price = 0
    recurring_plan = self.recurring_plan_invoice_item_for_community(community)
    upgrades = self.recurring_upgrade_invoice_items_for_community(community)
    price = price + recurring_plan.price_each unless recurring_plan.blank? or recurring_plan.price_each.blank?
    price = price + upgrades.map{|u| u.price_each * u.quantity}.inject(0,:+) unless upgrades.blank?
    return price
  end

  ###
  # Gets the total price per month in dollars for a specific communities plan and upgrades.
  # This will only count plans and upgrades saved to the database.
  ###
  def total_price_per_month_in_dollars_for_community(community)
    self.total_price_per_month_in_cents_for_community(community)/100.0
  end

  def total_recurring_price_per_month_in_cents
    price = 0
    saved_recurring_invoice_items = self.invoice_items.where{(is_recurring == true) & (is_prorated == false)}
    saved_recurring_invoice_items.each do |invoice_item|
      price = price + (invoice_item.price_each * invoice_item.quantity)
    end
    return price
  end

  def total_recurring_price_per_month_in_dollars
    self.total_recurring_price_per_month_in_cents/100.0
  end

  ###
  # Gets the total price per month in cents for all recurring plans and upgrades.
  # This will include unsaved invoice items.
  ###
  def new_total_recurring_price_per_month_in_cents
    price = 0
    self.recurring_invoice_items.each do |invoice_item|
      price = price + (invoice_item.item.price_per_month_in_cents * invoice_item.quantity)
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

  def recurring_plan_invoice_item_for_community(community)
    com_id = community.id
    some_plan = self.invoice_items.where{(item_type == "CommunityPlan") & (is_recurring == true) & (community_id == com_id) & (is_prorated == false) & (created_at != nil)}.limit(1).first
    if some_plan.blank?
      return self.invoice_items.new({item: CommunityPlan.default_plan, community: community, quantity: 1}, without_protection: true)
    else
      return some_plan
    end
  end

  def recurring_upgrade_invoice_items_for_community(community)
    com_id = community.id
    return self.invoice_items.where{(item_type != "CommunityPlan") & (is_recurring == true) & (community_id == com_id) & (is_prorated == false)}
  end

  # Returns all recurring invoice items including unsaved ones.
  def recurring_invoice_items
    recurring_items = []
    self.invoice_items.each do |invoice_item|
      recurring_items << invoice_item if invoice_item.is_recurring and not invoice_item.is_prorated
    end
    return recurring_items
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

#       is_valid = self.valid?
#       # HACK: WTF why does self.valid? not validate the invoice_items
#       self.invoice_items.each do |item|
#         break unless is_valid
#         is_valid = item.valid?
#         unless is_valid
#           throw item.errors
#         end
#       end

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
#

