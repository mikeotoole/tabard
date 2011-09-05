# == Schema Information
#
# Table name: community_profiles
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class CommunityProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
