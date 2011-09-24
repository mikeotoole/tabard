# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe CommunityProfile do
  let(:profile) { Factory.create(:community_profile) }
  let(:profile_with_characters) { create(:community_profile_with_characters) }
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

  describe "character_proxies" do
    it "should be allowed empty" do
      Factory.build(:community_profile, :character_proxies => Array.new).should be_valid
    end

    describe "Conditional finders" do
      it "approved_character_proxies should be all the approved proxies" do
        profile_with_characters.approved_character_proxies.each do |character_proxy|
          character_proxy.roster_assignments.size.should eq(1)
          character_proxy.roster_assignments.first.pending.should be_false
        end
      end
      it "pending_character_proxies should be all the pending proxies" do
        profile_with_characters.pending_character_proxies.each do |character_proxy|
          character_proxy.roster_assignments.size.should eq(1)
          character_proxy.roster_assignments.first.pending.should be_true
        end
      end
      it "character_proxies should be all the proxies" do
        profile_with_characters.approved_character_proxies.each do |character_proxy|
          profile_with_characters.character_proxies.include?(character_proxy).should be_true
        end
        profile_with_characters.pending_character_proxies.each do |character_proxy|
          profile_with_characters.character_proxies.include?(character_proxy).should be_true
        end
        expected_size = profile_with_characters.pending_character_proxies.size + profile_with_characters.approved_character_proxies.size
        profile_with_characters.character_proxies.size.should eq(expected_size)
      end
    end

    describe "adding" do
      it "should not allow character_proxies from users other than the one this is attached to" do
        original_character_proxies_count = profile_with_characters.character_proxies.size
        invalid_character_proxy = create(:billy).user_profile.character_proxies.first
        invalid_character_proxy.user_profile.should_not eq(profile_with_characters.user_profile)
        lambda{profile_with_characters.character_proxies << invalid_character_proxy}.should raise_error
        profile_with_characters.character_proxies.size.should eq(original_character_proxies_count)
      end

      it "should allow character from the same user as the one this is attached to" do
        new_character_proxy = create(:character_proxy_with_wow_character, :user_profile => profile_with_characters.user_profile)
        profile_with_characters.character_proxies << new_character_proxy
        profile_with_characters.character_proxies.include?(new_character_proxy).should be_true
      end
    end
  end
end
