###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Represents a plan used by a community. This controls the features allowed.
###
class CommunityPlan < ActiveRecord::Base
  # What the free plan is called.
  FREE_PLAN_TITLE = "Free"

###
# Attribute accessible
###
  attr_accessible :title, :description, :is_available, :max_number_of_users, :price_per_month_in_cents

###
# Associations
###
  has_many :communities
  has_many :community_plan_upgrades
  has_many :community_upgrades, through: :community_plan_upgrades
  has_many :invoice_items, as: :item

###
# Validators
###
  validates :title, presence: true
  validates :description, presence: true
  validates :price_per_month_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :max_number_of_users, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validate :no_changing_price, on: :update
  validate :no_changing_free_plan_title, on: :update

###
# Scopes
###
  scope :available, lambda { where{(is_available == true)}.order :price_per_month_in_cents }

###
# Public Methods
###

###
# Class Methods
###
  # Returns the current default Free plan for communities.
  def self.default_plan
    plan = CommunityPlan.find_by_title(FREE_PLAN_TITLE)
    if plan.blank?
      plan = CommunityPlan.create!({
        title: FREE_PLAN_TITLE,
        description: "This is the default free plan.",
        price_per_month_in_cents: 0,
        is_available: true,
        max_number_of_users: 20
        }, without_protection: true)
    end
    return plan
  end

###
# Instance Methods
###
  # Returns true if this is a free plan, false otherwise.
  def is_free_plan?
    return self.title == FREE_PLAN_TITLE
  end

  # Determines if an upgrade is compatable
  def is_compatable_with_upgrade?(upgrade)
    self.community_upgrades.include? upgrade
  end

  # Cost per month for upgrade in dollars.
  def price_per_month_in_dollars
    self.price_per_month_in_cents/100.0
  end

  # Don't allow anyone to destroy a CommunityPlan that has InvoiceItems
  def destroy
    if self.invoice_items.any?
      self.errors.add(:base, "Cannot destroy CommunityPlans that are attached to InvoiceItems")
      return false
    else
      super
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
  # Validates plan can not change price. Invoice items rely on this price.
  ###
  def no_changing_price
    if self.price_per_month_in_cents_changed?
      self.errors.add(:price_per_month_in_cents, "can not be changed")
    end
  end

  ###
  # _Validator_
  #
  # Validates the free plan can't have it's title changed.
  # This should only be changed using the constant FREE_PLAN_TITLE.
  # To change title:
  #  1. Put site in maintenance mode
  #  2. Push new code with constant "FREE_PLAN_TITLE" changed
  #  3. Change title in console.
  ###
  def no_changing_free_plan_title
    if self.title_changed? and self.title_was == FREE_PLAN_TITLE
      self.errors.add(:title, "can not be changed on free plan. Please change in model using constant and then in db using console.")
    end
  end
end

# == Schema Information
#
# Table name: community_plans
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  description              :text
#  price_per_month_in_cents :integer
#  is_available             :boolean          default(TRUE)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  max_number_of_users      :integer          default(0)
#

