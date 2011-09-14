# == Schema Information
#
# Table name: permissions
#
#  id               :integer         not null, primary key
#  role_id          :integer
#  action           :string(255)
#  permission_level :string(255)
#  subject_class    :string(255)
#  id_of_subject    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
