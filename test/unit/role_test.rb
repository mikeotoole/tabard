# == Schema Information
#
# Table name: roles
#
#  id               :integer         not null, primary key
#  community_id     :integer
#  name             :string(255)
#  system_generated :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
