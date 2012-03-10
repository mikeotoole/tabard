# == Schema Information
#
# Table name: community_profiles
#
#  id                       :integer         not null, primary key
#  community_id             :integer
#  user_profile_id          :integer
#  created_at               :datetime
#  updated_at               :datetime
#  deleted_at               :datetime
#  community_application_id :integer
#

require 'spec_helper'

describe CommunityProfile do
  let(:profile) { Factory.create(:community_profile, :community => FactoryGirl.create(:community_with_supported_games)) }
  let(:community) { profile.community }
  let(:profile_with_characters) { create(:community_profile_with_characters) }
  let(:some_other_community) { create(:community) }

  it "should create a new instance given valid attributes" do
    profile.should be_valid
  end

###
# Attribute Tests
###
  it "should require a user_profile" do
    lambda { Factory.build(:community_profile, :user_profile => nil, :community_application => FactoryGirl.create(:community_application, character_proxies: Array.new, community: community, user_profile: nil, submission: FactoryGirl.create(:submission, :custom_form_id => community.community_application_form.id, :user_profile_id => nil))).should_not be_valid }.should raise_error
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
          character_proxy.roster_assignments.first.is_pending.should be_false
        end
      end
      it "pending_character_proxies should be all the pending proxies" do
        profile_with_characters.pending_character_proxies.each do |character_proxy|
          character_proxy.roster_assignments.size.should eq(1)
          character_proxy.roster_assignments.first.is_pending.should be_true
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
  end
  
  describe "destroy" do
    it "should mark community_profile as deleted" do
      profile.destroy
      CommunityProfile.exists?(profile).should be_false
      CommunityProfile.with_deleted.exists?(profile).should be_true
    end
    
    it "should mark roster assignments as deleted" do
      roster = profile_with_characters.roster_assignments.first
      roster.should be_a(RosterAssignment)
      RosterAssignment.exists?(roster).should be_true
      
      profile_with_characters.destroy
      RosterAssignment.exists?(roster).should be_false
      RosterAssignment.with_deleted.exists?(roster).should be_true
    end
  end
end
