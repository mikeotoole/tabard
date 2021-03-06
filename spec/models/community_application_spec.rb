# == Schema Information
#
# Table name: community_applications
#
#  id                :integer          not null, primary key
#  community_id      :integer
#  user_profile_id   :integer
#  submission_id     :integer
#  status            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status_changer_id :integer
#  deleted_at        :datetime
#

require 'spec_helper'

describe CommunityApplication do
  let(:community_application) { create(:community_application) }
  let(:community) { community_application.community }
  let(:user_profile) { community_application.user_profile }

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
      community_application.is_pending?.should be_true
    end

    it "should allow the pending status" do
      community_application.status = "Pending"
      community_application.valid?.should be_true
      community_application.is_pending?.should be_true
    end

    it "should allow the accepted status" do
      community_application.status = "Accepted"
      community_application.valid?.should be_true
      community_application.accepted?.should be_true
    end

    it "should allow the rejected status" do
      community_application.status = "Rejected"
      community_application.valid?.should be_true
      community_application.rejected?.should be_true
    end

    it "should allow the withdrawn status" do
      community_application.status = "Withdrawn"
      community_application.valid?.should be_true
      community_application.withdrawn?.should be_true
    end
  end

  describe "accept_application" do
    before(:each) do
      community_application.user_profile.is_member?(community).should be_false
      community_application.is_pending?.should be_true
    end

    it "should make the applicant a member of the community" do
      community_application.accept_application(community.admin_profile).should be_true
      UserProfile.find(community_application.user_profile).is_member?(community).should be_true
    end

    it "should automaticaly add and approve the characters used for the application" do
      mapping = Hash.new
      community_application.characters.each do |character|
        cg = community_application.community.community_games.where(:game_id => character.game.id).first
        mapping[character.id.to_s] = cg.id.to_s if cg
      end
      community_application.accept_application(community.admin_profile, mapping).should be_true

      community_profile = user_profile.community_profiles.where(:community == community).first
      community_application.characters.each do |character|
        community_profile.approved_characters.include?(character).should be_true
      end
      community_profile.pending_characters.size.should eq(0)
    end

    it "should set the application to the accepted status" do
      community_application.accept_application(community.admin_profile).should be_true
      community_application.accepted?.should be_true
    end

    it "should should not work if the application is not pending" do
      community_application.accept_application(community.admin_profile).should be_true
      community_application.is_pending?.should be_false
      community_application.accept_application(community.admin_profile).should be_false
    end

    it "should send a message to the applicant" do
      expect {
        community_application.accept_application(community.admin_profile).should be_true
      }.to change(Message, :count).by(1)
    end

    it "should set status_changer" do
      community_application.accept_application(community.admin_profile).should be_true
      community_application.status_changer.should eql community.admin_profile
    end
  end

  describe "reject_application" do
    before(:each) do
      community_application.user_profile.is_member?(community).should be_false
      community_application.is_pending?.should be_true
    end

    it "should not make the applicant a member of the community" do
      community_application.reject_application(community.admin_profile).should be_true
      community_application.user_profile.is_member?(community).should be_false
    end

    it "should set the application to the rejected status" do
      community_application.reject_application(community.admin_profile).should be_true
      community_application.rejected?.should be_true
    end

    it "should should not work if the application is not pending" do
      community_application.reject_application(community.admin_profile).should be_true
      community_application.is_pending?.should be_false
      community_application.reject_application(community.admin_profile).should be_false
    end

    it "should send a message to the applicant" do
      expect {
        community_application.reject_application(community.admin_profile).should be_true
      }.to change(Message, :count).by(1)
    end

    it "should set status_changer" do
      community_application.reject_application(community.admin_profile).should be_true
      community_application.status_changer.should eql community.admin_profile
    end
  end

  describe "withdraw" do
    before(:each) do
      community_application.user_profile.is_member?(community).should be_false
    end

    it "should allow withdrawl if pending" do
      community_application.is_pending?.should be_true
      community_application.withdraw.should be_true
      community_application.withdrawn?.should be_true
    end

    it "should not allow withdrawl if accepted" do
      community_application.accept_application(community.admin_profile).should be_true
      community_application.withdraw.should be_false
      community_application.withdrawn?.should be_false
    end

    it "should not allow withdrawl if rejected" do
      community_application.reject_application(community.admin_profile).should be_true
      community_application.withdraw.should be_false
      community_application.withdrawn?.should be_false
    end
  end

  describe "destroy" do
    it "should mark community_application as deleted" do
      community_application.destroy
      CommunityApplication.exists?(community_application).should be_false
      CommunityApplication.with_deleted.exists?(community_application).should be_true
    end

    it "should mark community_application's submission as deleted" do
      submission = community_application.submission
      submission.should be_a(Submission)

      community_application.destroy
      Submission.exists?(submission).should be_false
      Submission.with_deleted.exists?(submission).should be_true
    end

    it "should mark community_application's comments as deleted" do
      community_application = create(:community_application_with_comment)
      comment = community_application.comments.first
      comment.should be_a(Comment)

      community_application.destroy
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_true
    end
  end
end
