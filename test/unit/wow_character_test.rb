# == Schema Information
#
# Table name: wow_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  faction    :string(255)
#  race       :string(255)
#  level      :integer
#  server     :string(255)
#  game_id    :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class WowCharacterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
