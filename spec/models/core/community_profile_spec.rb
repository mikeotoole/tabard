# == Schema Information
#
# Table name: community_profiles
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe CommunityProfile do
  let(:profile) { Factory.create(:community_profile) }
  let(:community) { profile.community }
  let(:some_other_community) { create(:community) }

  it "should create a new instance given valid attributes" do
    profile.should be_valid
  end

###
# Attribute Tests
###
  it "should require a user_profile" do
    Factory.build(:community_profile, :user_profile => nil).should_not be_valid
  end

  it "should require a community" do
    Factory.build(:community_profile_with_nil_community).should_not be_valid
  end
  describe "roles" do
    it "should not be empty" do
      Factory.build(:community_profile, :roles => Array.new).should_not be_valid
    end

    it "should not allow excluding the member role" do
      Factory.build(:community_profile, :roles => []).should_not be_valid
    end

    describe "adding" do
      it "should not allow roles from other communities" do
        original_role_count = profile.roles.size
        lambda{profile.roles << some_other_community.member_role}.should raise_error
        profile.roles.size.should eq(original_role_count)
      end

      it "should allow roles from the same community" do
        new_role = create(:role, :community => community)
        profile.roles << new_role
        profile.roles.include?(new_role).should be_true
      end
    end

    describe "removing" do
      it "should not allow the member role to be removed" do
        lambda{profile.roles.delete(community.member_role)}.should raise_error
      end
      it "should allow non member roles to be removed" do
        new_role = create(:role, :community => community)
        original_role_count = profile.roles.size
        profile.roles << new_role
        profile.roles.size.should eq(original_role_count + 1)
        profile.roles.delete(new_role)
        profile.roles.size.should eq(original_role_count)
      end
    end
  end
end