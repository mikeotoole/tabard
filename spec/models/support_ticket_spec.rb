# == Schema Information
#
# Table name: support_tickets
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  admin_user_id   :integer
#  status          :string(255)
#  body            :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe SupportTicket do
  let(:support_ticket) { create(:support_ticket) }

  it "should create a new instance given valid attributes" do
    support_ticket.should be_valid
  end
  describe "user_profile" do
    it "should be required" do
      build(:support_ticket, :user_profile => nil).should_not be_valid
    end
  end

  describe "status" do
    it "should be required" do
      build(:support_ticket, :status => nil).should_not be_valid
    end
    it "should not be blank" do
      build(:support_ticket, :status => "").should_not be_valid
    end
    it "should be pending review by default" do
      build(:support_ticket).status.should eq("Pending Review")
    end
  end

  describe "body" do
    it "should be required" do
      build(:support_ticket, :body => nil).should_not be_valid
    end
    it "should not be blank" do
      build(:support_ticket, :body => "").should_not be_valid
    end
  end
end
