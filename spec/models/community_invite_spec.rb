# == Schema Information
#
# Table name: community_invites
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  sponsor_id   :integer
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe CommunityInvite do
  let(:community_invite) { create(:community_invite) }

  it "should create a new instance given valid attributes" do
    community_invite.should be_valid
  end

  it "should only allow one invite per sponsor/applicant/community combo" do
    community_invite.should be_valid
    build(:community_invite, applicant: community_invite.applicant, sponsor: community_invite.sponsor, community: community_invite.community).should_not be_valid
  end

  describe "applicant" do
    it "should be required" do
      build(:community_invite, applicant: nil).should_not be_valid
    end
    it "can't be the same as the sponsor" do
      user_profile = DefaultObjects.community.admin_profile
      build(:community_invite, applicant: user_profile, sponsor: user_profile, community: DefaultObjects.community).should_not be_valid
    end
  end

  describe "sponsor" do
    it "should be required" do
      build(:community_invite, sponsor: nil).should_not be_valid
    end
    it "should be in the same community as the invite" do
      some_community = create(:community)
      DefaultObjects.community.admin_profile.is_member?(some_community).should be_false
      build(:community_invite, community: some_community).should_not be_valid
    end
  end

  describe "community" do
    it "should be required" do
      build(:community_invite, community: nil).should_not be_valid
    end
  end
end
