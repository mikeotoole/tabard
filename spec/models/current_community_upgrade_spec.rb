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

require 'spec_helper'

describe CurrentCommunityUpgrade do
  let(:current_community_upgrade) { create(:current_community_upgrade) }
  it "should create a new instance given valid attributes" do
    current_community_upgrade.should be_valid
  end
  describe "community" do
    it "should only allow one per community" do
      build(:current_community_upgrade, community: current_community_upgrade.community, community_upgrade: current_community_upgrade.community_upgrade).should_not be_valid
    end
  end
  describe "community_upgrade" do
    it "should be in the upgrades that the community plan has" do
      valid_plan = create(:community_plan_upgrade).community_plan
      invalid_plan = create(:community_plan_upgrade).community_plan
      community = create(:community, community_plan: valid_plan)
      valid_plan.community_upgrades.include?(invalid_plan.community_upgrades.first).should be_false
      build(:current_community_upgrade, community: community, community_upgrade: valid_plan.community_upgrades.first).should be_valid
      build(:current_community_upgrade, community: community, community_upgrade: invalid_plan.community_upgrades.first).should_not be_valid
    end
  end
end
