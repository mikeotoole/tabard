require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before(:each) do
    AvatarUploader.enable_processing = true
  end

  after(:all) do
    AvatarUploader.enable_processing = false
  end

  it "should accept valid file types" do
    goodFilenames = %w{ goodAvatar1.jpg goodAvatar2.jpeg goodAvatar3.png goodAvatar4.gif } # TESTING Valid avatar files for testing
    goodFilenames.each do |filename|
      build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should be_valid
    end
  end

  it "should reject invalid file types" do
    badFilenames = %w{ badAvatarFileType1.tiff } # TESTING Invalid avatar file type for testing  
    badFilenames.each do |filename|
      build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
    end
  end
end
