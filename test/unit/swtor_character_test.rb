# == Schema Information
#
# Table name: swtor_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  server     :string(255)
#  game_id    :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SwtorCharacterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
