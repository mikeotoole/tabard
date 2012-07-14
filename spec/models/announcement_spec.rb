# == Schema Information
#
# Table name: announcements
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  community_id       :integer
#  supported_game_id  :integer
#  is_locked          :boolean         default(FALSE)
#  deleted_at         :datetime
#  has_been_edited    :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe Announcement do
  let(:announcement) { create(:announcement) }

  it "should create a new instance given valid attributes" do
    announcement.should be_valid
  end

  describe "name" do
    it "should required" do
      build(:announcement, :name => nil).should_not be_valid
    end
  end

  describe "body" do
    it "should not be required" do
      build(:announcement, :body => nil).should be_valid
    end
  end

  describe "user_profile" do
    it "should required" do
      build(:announcement, :user_profile => nil).should_not be_valid
    end
  end  

  describe "community" do
    it "should required" do
      build(:announcement, :community => nil).should_not be_valid
    end
  end

  describe "character_is_valid_for_user_profile" do
    it "should be optional" do
      build(:announcement, :character_proxy_id => nil).should be_valid
    end
  end

  describe "after create" do
    describe "acknowledgements" do
      it "should create these" do
        announcement.acknowledgements.size.should eq(1)
      end
    end
  end
end
