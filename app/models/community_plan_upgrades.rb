class CommunityPlanUpgrades < ActiveRecord::Base
  belongs_to :community_plan
  belongs_to :community_upgrade
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

