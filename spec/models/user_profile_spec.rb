# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe UserProfile do
  let(:profile) { Factory.create(:user_profile) }

  it "should create a new instance given valid attributes" do
    profile.should be_valid
  end

  it "should require a first name" do
    Factory.build(:user_profile, :first_name => nil).should_not be_valid
  end

  it "should require a last name" do
    Factory.build(:user_profile, :last_name => nil).should_not be_valid
  end

  it "should require a user" do
    Factory.build(:user_profile, :user => nil).should_not be_valid
  end

  describe "avatars" do
    before(:all) do
      AvatarUploader.enable_processing = true
    end
    
    after(:all) do
      AvatarUploader.enable_processing = false
    end

    it "should reject invalid file sizes" do
      badFilenames = %w{ tooBigAvatar1.jpg } # TESTING Invalid avatar file size for testing
      badFilenames.each do |filename|
        Factory.build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
      end  
    end
  end
end
