# == Schema Information
#
# Table name: roster_assignments
#
#  id                   :integer         not null, primary key
#  community_profile_id :integer
#  character_proxy_id   :integer
#  is_pending           :boolean         default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe RosterAssignment do
  let(:roster_assignment) { create(:roster_assignment) }

  it "should create a new instance given valid attributes" do
    roster_assignment.should be_valid
  end
  
  describe "is_pending" do
    it "should be true by default" do
      build(:roster_assignment).is_pending.should be_true
    end
  end

  describe "community_profile" do
  	it "should be required" do
      build(:roster_assignment, :community_profile => nil).should_not be_valid
    end
  end

  describe "character_proxy" do
  	it "should be required" do
      build(:roster_assignment, :character_proxy => nil).should_not be_valid
    end
  end

  it "should enforce character non-duplication within a roster" do
    profile_with_characters = create(:community_profile_with_characters)
    the_proxy = profile_with_characters.character_proxies.first
    RosterAssignment.new(:character_proxy => the_proxy, :community_profile => profile_with_characters).should_not be_valid
  end

  describe "approve" do
    before(:each) do
      roster_assignment.update_attribute(:is_pending, true)
    end
    
    it "should remove the pending status" do
      roster_assignment.approve
      RosterAssignment.find(roster_assignment).is_pending.should be_false
    end
    
    it "should send message to user" do
      expect {
        roster_assignment.approve
      }.to change(Message, :count).by(1)
    end
  end

  describe "reject" do
    before(:each) do
      roster_assignment.update_attribute(:is_pending, true)
    end
    
    it "should remove the roster assignment" do
      roster_assignment.reject
      RosterAssignment.exists?(roster_assignment).should be_false
    end
    
    it "should send message to user" do
      expect {
        roster_assignment.reject
      }.to change(Message, :count).by(1)
    end
  end
end
