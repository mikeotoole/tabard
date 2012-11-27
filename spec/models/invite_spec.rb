# == Schema Information
#
# Table name: invites
#
#  id                 :integer          not null, primary key
#  event_id           :integer
#  user_profile_id    :integer
#  character_proxy_id :integer
#  status             :string(255)
#  is_viewed          :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  expiration         :datetime
#  character_id       :integer
#

require 'spec_helper'

describe Invite do
  let(:invite) { create(:invite) }

  it "should create a new instance given valid attributes" do
    invite.should be_valid
  end

  describe "event" do
    it "should be required" do
      build(:invite, :event => nil).should_not be_valid
    end
  end

  describe "user_profile" do
    it "should be required" do
      build(:invite, :user_profile => nil).should_not be_valid
    end
  end

  describe "character" do
    it "should not be required" do
      build(:invite, :character => nil).should be_valid
    end
  end

  describe "status" do
    it "should be required on update" do
      invite.update_viewed(invite.user_profile)
      invite.update_attributes({status: nil}, without_protection: true).should_not be_true
    end
    it "should not be required on create" do
      build(:invite, :status => nil).should be_valid
    end
  end
end
