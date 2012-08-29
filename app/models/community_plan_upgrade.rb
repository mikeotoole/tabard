class CommunityPlanUpgrade < ActiveRecord::Base
  belongs_to :community_plan, inverse_of: :community_plan_upgrades
  belongs_to :community_upgrade, inverse_of: :community_plan_upgrades
end

# == Schema Information
#
# Table name: community_plan_upgrades
#
#  id                   :integer          not null, primary key
#  community_plan_id    :integer
#  community_upgrade_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

