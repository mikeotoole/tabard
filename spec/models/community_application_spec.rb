# == Schema Information
#
# Table name: community_applications
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  submission_id   :integer
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe CommunityApplication do
  let(:community_application) { create(:community_application) }
  let(:community) { community_application.community }

  it "should create a new instance given valid attributes" do
    community_application.should be_valid
  end

  describe "community" do
  	it "should be required" do
      build(:community_application, :community => nil).should_not be_valid
    end
  end

  describe "user_profile" do
  	it "should be required" do
      build(:community_application, :user_profile => nil).should_not be_valid
    end

    it "should not allow user_profile to not match submission" do
      build(:community_application, :user_profile => create(:user_profile)).should_not be_valid
    end

    it "should not allow user_profile to be a member already" do
      member_profile = DefaultObjects.community.admin_profile
      submission = create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => member_profile) 
      build(:community_application, :user_profile => member_profile).should_not be_valid
    end
  end

  describe "submission" do
  	it "should be required" do
      build(:community_application, :submission => nil).should_not be_valid
    end

    it "should not allow submission to not match community application form" do
      build(:community_application, :submission => create(:submission)).should_not be_valid
    end
  end

  describe "status" do
  	it "should not be required" do
      build(:community_application, :status => nil).should be_valid
    end

    it "should be set to pending automatically" do
      community_application.status.should eq("Pending")
    end

    it "should allow the pending status" do
      community_application.status = "Pending"
      community_application.valid?.should be_true
    end

    it "should allow the accepted status" do
      community_application.status = "Accepted"
      community_application.valid?.should be_true
    end

    it "should allow the rejected status" do
      community_application.status = "Rejected"
      community_application.valid?.should be_true
    end
  end

  describe "accept_application" do
    before(:each) do
      community_application.user_profile.is_member?(community).should be_false
    end

    it "should make the applicant a member of the community" do
      pending
    end

    it "should automaticaly add and approve the characters used for the application" do
      pending
    end

    it "should set the application to the accepted status" do
      pending
    end
  end

  describe "reject_application" do
  end
end
