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

require 'spec_helper'

describe CommunityPlanUpgrade do
  let(:community_plan_upgrade) { create(:community_plan_upgrade) }
  it "should create a new instance given valid attributes" do
    community_plan_upgrade.should be_valid
  end

  describe "upgrade" do
    it "should be unique with plans" do
      build(:community_plan_upgrade, community_plan: community_plan_upgrade.community_plan, community_upgrade: community_plan_upgrade.community_upgrade).should_not be_valid
      build(:community_plan_upgrade, community_plan: community_plan_upgrade.community_plan).should be_valid
      build(:community_plan_upgrade, community_upgrade: community_plan_upgrade.community_upgrade).should be_valid
    end
  end
end
