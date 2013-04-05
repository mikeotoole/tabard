###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community upgrade.
###
class CommunityUpgrade < ActiveRecord::Base
###
# Constants
###
  # This is a collection of strings that are valid for subject classes.
  VALID_TYPES = %w( CommunityUserPackUpgrade )

###
# Attribute accessible
###
  attr_accessible :title, :description, :max_number_of_upgrades, :price_per_month_in_cents

###
# store
###
  store :upgrade_options, accessors: [:number_of_users]

###
# Associations
###
  has_many :community_plan_upgrades, inverse_of: :community_upgrade
  has_many :community_plans, through: :community_plan_upgrades
  has_many :current_community_upgrades, inverse_of: :community_upgrade
  has_many :communities, through: :current_community_upgrades
  has_many :invoice_items, as: :item

###
# Validators
###
  validates :title, presence: true
  validates :description, presence: true
  validates :type,
      presence: true,
      inclusion: { in: VALID_TYPES, message: "%{value} is not a valid upgrade type" }
  validates :price_per_month_in_cents,
      presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :max_number_of_upgrades,
      presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validate :no_changing_price, on: :update

###
# Instance Methods
###
  # Cost per month for upgrade in dollars.
  def price_per_month_in_dollars
    self.price_per_month_in_cents/100.0
  end

  # Don't allow anyone to destroy a CommunityUpgrade that has InvoiceItems
  def destroy
    if self.invoice_items.any?
      self.errors.add(:base, "Cannot destroy CommunityUpgrades that are attached to InvoiceItems")
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
  # Validates plan upgrade can not change price. Invoice items rely on this price.
  ###
  def no_changing_price
    if self.price_per_month_in_cents_changed?
      self.errors.add(:base, "price can not be changed.")
    end
  end
end

# == Schema Information
#
# Table name: community_upgrades
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  description              :text
#  price_per_month_in_cents :integer
#  max_number_of_upgrades   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  type                     :string(255)
#  upgrade_options          :text
#

