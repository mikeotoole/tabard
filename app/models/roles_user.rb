class RolesUser < ActiveRecord::Base
  attr_accessible :user, :role
  belongs_to :user
  belongs_to :role
end

# == Schema Information
#
# Table name: roles_users
#
#  role_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

