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
  test "user profile attributes must not be empty" do
    user_profile = UserProfile.new
    assert user_profile.invalid?
    assert user_profile.errors[:first_name].any?
    assert user_profile.errors[:last_name].any?
    assert user_profile.errors[:user].any?
  end

  test "user profile should validate avatar" do
    flunk "This needs to be figured out..." # TODO This test needs to be written.
  end
end
