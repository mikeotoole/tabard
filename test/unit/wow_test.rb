# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  is_active  :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class WowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
