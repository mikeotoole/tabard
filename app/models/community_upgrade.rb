class CommunityUpgrade < ActiveRecord::Base
  has_many :community_plan_upgrades, inverse_of: :community_upgrade
  has_many :community_plans, through: :community_plan_upgrades
  has_many :current_community_upgrades, inverse_of: :community_upgrade
  has_many :communities, through: :current_community_upgrades
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
#

