# == Schema Information
#
# Table name: supported_games
#
#  id           :integer         not null, primary key
#  community_id :integer
#  game_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class SupportedGameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
