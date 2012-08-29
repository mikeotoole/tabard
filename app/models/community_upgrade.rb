class CommunityUpgrade < ActiveRecord::Base

###
# Constants
###
  # This is a collection of strings that are valid for subject classes.
  VALID_TYPES = %w( CommunityUserPackUpgrade )

###
# Associations
###
  has_many :community_plan_upgrades, inverse_of: :community_upgrade
  has_many :community_plans, through: :community_plan_upgrades
  has_many :current_community_upgrades, inverse_of: :community_upgrade
  has_many :communities, through: :current_community_upgrades

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
#

