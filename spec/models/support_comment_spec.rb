# == Schema Information
#
# Table name: support_comments
#
#  id                :integer         not null, primary key
#  support_ticket_id :integer
#  user_profile_id   :integer
#  admin_user_id     :integer
#  body              :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
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
  end
end
