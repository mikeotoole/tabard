# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  pretty_url :string(255)
#

require 'test_helper'

class WowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
