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

require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase

  ###
  # Fixtures
  ###
  fixtures :user_profiles

  test "User profile attributes must not be empty" do
    user_profile = UserProfile.new
    assert user_profile.invalid?, "New UserProfile should be invalid."
    assert user_profile.errors[:first_name].any?, "Should not allow blank first name on creation."
    assert user_profile.errors[:last_name].any?, "Should not allow blank last name on creation."
    assert user_profile.errors[:user].any?, "Should not allow blank user on creation."
  end

  test "User profile should validate avatar" do
    user_profile = user_profiles(:billy)

    goodFilenames = %w{ goodAvatar1.jpg goodAvatar2.jpeg goodAvatar3.png goodAvatar4.gif } # TESTING Valid avatar files for testing
    badFilenames = %w{ badAvatar1.jpg badAvatar2.tiff } # TESTING Invalid avatar files for testing


    goodFilenames.each do |filename|
      begin
        user_profile.avatar = File.open("#{Rails.root}/test/fixtures/files/#{filename}")
        assert user_profile.valid?, "#{filename} should be valid."
      rescue Errno::ENOENT
        puts "Avatar testing file #{filename} not found."
      end
    end

    badFilenames.each do |filename|
      begin
        user_profile.avatar = File.open("#{Rails.root}/test/fixtures/files/#{filename}")
        assert user_profile.invalid?, "#{filename} shouldn't be valid."
      rescue Errno::ENOENT
        puts "Avatar testing file #{filename} not found."
      end
    end

  end

  # test "User profile remove_avatar should set avatar to nil" do
  #   user_profile = user_profiles(:billy)
  #
  #   begin
  #     filename = "goodAvatar1.jpg"
  #     user_profile.avatar = File.open("#{Rails.root}/test/fixtures/files/#{filename}")
  #     assert user_profile.valid?, "#{filename} should be valid."
  #     user_profile.update_attribute(:remove_avatar, true)
  #     assert_nil user_profile.avatar, "Avatar should be nil."
  #   rescue Errno::ENOENT
  #     puts "Avatar testing file #{filename} not found."
  #   end
  # end

end
