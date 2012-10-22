# == Schema Information
#
# Table name: support_comments
#
#  id                :integer          not null, primary key
#  support_ticket_id :integer
#  user_profile_id   :integer
#  admin_user_id     :integer
#  body              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe SupportComment do
  let(:support_comment) { create(:support_comment) }

  it "should create a new instance given valid attributes" do
    support_comment.should be_valid
  end

  describe "user_profile" do
    it "should be required if admin_user is blank" do
      build(:support_comment, :user_profile => nil, :admin_user => nil).should_not be_valid
    end
    it "should not be set if admin_user is not blank" do
      build(:support_comment, :user_profile => FactoryGirl.create(:user_profile), :admin_user => FactoryGirl.create(:admin_user)).should_not be_valid
    end
  end

  describe "admin_user" do
    it "should be required if user_profile is blank" do
      build(:support_comment, :user_profile => nil, :admin_user => nil).should_not be_valid
    end
    it "should not be set if user_profile is not blank" do
      build(:support_comment, :user_profile => FactoryGirl.create(:user_profile), :admin_user => FactoryGirl.create(:admin_user)).should_not be_valid
    end
  end

  describe "body" do
    it "should be required" do
      build(:support_comment, :body => nil).should_not be_valid
    end
    it "should not be allowed to be blank" do
      build(:support_comment, :body => "").should_not be_valid
    end
  end

  describe "close_comment" do
    it "should not be required" do
      build(:support_comment, close_comment: nil).should be_valid
    end
    describe "if true" do
      it "should allow body to be not required if true" do
        build(:support_comment, close_comment: "1", body: nil).should be_valid
      end
      it "should allow body to be blank if true" do
        build(:support_comment, close_comment: "1", body: "").should be_valid
      end
      it "should close the ticket after save" do
        ticket = support_comment.support_ticket
        ticket.status.should_not eq "Closed"
        create(:support_comment, close_comment: "1", support_ticket: support_comment.support_ticket, user_profile: support_comment.user_profile).should be_true
        SupportTicket.find(ticket).status.should eq "Closed"
      end
      it "should add a default message to if none is provided" do
        ticket = support_comment.support_ticket
        ticket.status.should_not eq "Closed"
        new_comment = build(:support_comment, close_comment: "1", support_ticket: support_comment.support_ticket, user_profile: support_comment.user_profile, body: "")
        new_comment.save
        new_comment.body.blank?.should be_false
      end
    end
    describe "if false" do
      it "should require body if false" do
        build(:support_comment, close_comment: false, body: nil).should_not be_valid
      end
      it "should not allow body to be blank if false" do
        build(:support_comment, close_comment: false, body: "").should_not be_valid
      end
      it "should not close the ticket after save" do
        ticket = support_comment.support_ticket
        ticket.status.should_not eq "Closed"
        create(:support_comment, close_comment: false, support_ticket: support_comment.support_ticket, user_profile: support_comment.user_profile).should be_true
        SupportTicket.find(ticket).status.should_not eq "Closed"
      end
      it "should add a default message to if none is provided" do
        ticket = support_comment.support_ticket
        ticket.status.should_not eq "Closed"
        new_comment = build(:support_comment, close_comment: false, support_ticket: support_comment.support_ticket, user_profile: support_comment.user_profile, body: "")
        new_comment.save
        new_comment.body.blank?.should_not be_false
      end
    end
  end
end
