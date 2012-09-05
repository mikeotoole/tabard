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
# Associations
###
  has_many :communities
  has_many :community_plan_upgrades
  has_many :community_upgrades, through: :community_plan_upgrades

###
# Validators
###
  validates :title, presence: true
  validates :description, presence: true
  validates :price_per_month_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

###
# Scopes
###
  scope :available, lambda {
    where{(is_available == true)}
  }

###
# Public Methods
###

###
# Class Methods
###
  # Returns the current default Free plan for communities.
  def self.default_plan
    plan = CommunityPlan.find_by_title(FREE_PLAN_TITLE)
    if plan == nil
      return CommunityPlan.create({
        title: FREE_PLAN_TITLE,
        description: "This is the default free plan.",
        price_per_month_in_cents: 0,
        is_available: true,
        max_number_of_users: 20
        }, without_protection: true)
    else
      return plan
    end
  end

###
# Instance Methods
###
  # Returns true if this is a free plan, false otherwise.
  def is_free_plan?
    return self.title == FREE_PLAN_TITLE
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
#

