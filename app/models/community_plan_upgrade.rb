###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Used to connect plans to upgrades. This represents valid upgrades for a plan.
###
class CommunityPlanUpgrade < ActiveRecord::Base
###
# Associations
###
  belongs_to :community_plan, inverse_of: :community_plan_upgrades
  belongs_to :community_upgrade, inverse_of: :community_plan_upgrades

###
# Validators
###
  validates :community_plan_id, uniqueness: {scope: [:community_upgrade_id]}
  validates :community_plan, presence: true
  validates :community_upgrade, presence: true
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

