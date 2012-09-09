###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Represents the upgrades that a community has.
###
class CurrentCommunityUpgrade < ActiveRecord::Base
  attr_accessible :community_upgrade_id, :number_in_use

###
# Associations
###
  belongs_to :subscription_package, inverse_of: :current_community_upgrades
  belongs_to :community_upgrade, inverse_of: :current_community_upgrades

###
# Validators
###
  validate :upgrade_is_compatable

###
# Callbacks
###
  before_save :update_amounts

  ###
  # Returns the number of community upgrades that are currently allowed.
  # A community could have a higher number of upgrades currently allowed
  # from its previous subscription then from the currently subscribed to plan.
  ###
  def current_amount
    number_in_use
  end

  # Returns the total price for all community upgrades of a single type in cents.
  def total_price_per_month_in_cents
    unless self.marked_for_destruction?
      self.number_in_use * self.community_upgrade.price_per_month_in_cents
    else
      0
    end
  end

  # Returns the total price for all community upgrades of a single type in dollars.
  def total_price_per_month_in_dollars
    self.total_price_per_month_in_cents/100.0
  end


###
# Protected Methods
###
protected
  ###
  # _before_save_
  #
  # This method sets the subscription amount to the number of upgrades the community is subscribed to.
  ###
  def update_amounts
    # TODO Fix This
    #if number_in_use_changed?
    #  if not number_in_use_was.blank? and number_in_use_was > number_in_use
    #    self.subcription_amount = number_in_use_was
    #  else
    #    self.subcription_amount = number_in_use
    #  end
    #else
    #  return true
    #end
  end

###
# Validator Methods
###
  ###
  # _validator_
  #
  # This method ensures that the community's plan allows the upgrade.
  ###
  def upgrade_is_compatable
    # TODO Fix this
    #unless self.community.community_plan.community_upgrades.include? self.community_upgrade
    #  errors.add(:community_upgrade, "is not compatable with the community's plan.")
    #  return false
    #end
  end
end

# == Schema Information
#
# Table name: current_community_upgrades
#
#  id                      :integer          not null, primary key
#  community_upgrade_id    :integer
#  number_in_use           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  subscription_package_id :integer
#

