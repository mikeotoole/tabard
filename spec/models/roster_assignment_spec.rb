require 'spec_helper'

describe RosterAssignment do
  let(:roster_assignment) { create(:roster_assignment) }

  it "should create a new instance given valid attributes" do
    roster_assignment.should be_valid
  end
  
  describe "pending" do
    it "should be required" do
      build(:roster_assignment, :pending => nil).should_not be_valid
    end
    it "should be true by default" do
      build(:roster_assignment).pending.should be_true
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
end
