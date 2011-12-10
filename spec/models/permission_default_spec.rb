# == Schema Information
#
# Table name: permission_defaults
#
#  id                      :integer         not null, primary key
#  role_id                 :integer
#  object_class            :string(255)
#  permission_level        :string(255)
#  can_read                :boolean         default(FALSE)
#  can_update              :boolean         default(FALSE)
#  can_create              :boolean         default(FALSE)
#  can_destroy             :boolean         default(FALSE)
#  can_lock                :boolean         default(FALSE)
#  can_accept              :boolean         default(FALSE)
#  nested_permission_level :string(255)
#  can_read_nested         :boolean         default(FALSE)
#  can_update_nested       :boolean         default(FALSE)
#  can_create_nested       :boolean         default(FALSE)
#  can_destroy_nested      :boolean         default(FALSE)
#  can_lock_nested         :boolean         default(FALSE)
#  can_accept_nested       :boolean         default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#

require 'spec_helper'

describe PermissionDefault do
  pending "add some examples to (or delete) #{__FILE__}"
end
