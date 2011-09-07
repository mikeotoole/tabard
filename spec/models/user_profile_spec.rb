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
    it "should accept valid file types" do
      goodFilenames = %w{ goodAvatar1.jpg goodAvatar2.jpeg goodAvatar3.png goodAvatar4.gif } # TESTING Valid avatar files for testing
      goodFilenames.each do |filename|
        Factory.build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should be_valid
      end
    end

    it "should reject invalid file types" do
      badFilenames = %w{ badAvatarFileType1.tiff } # TESTING Invalid avatar file type for testing  
      badFilenames.each do |filename|
        Factory.build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
      end
    end

    it "should reject invalid file sizes" do
      badFilenames = %w{ tooBigAvatar1.jpg } # TESTING Invalid avatar file size for testing
      badFilenames.each do |filename|
        Factory.build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
      end
    end
  end
end
