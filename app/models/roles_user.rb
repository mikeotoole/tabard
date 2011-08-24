=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a roles_user. This is an item that allows for a many to many relationship between roles and users.
=end
class RolesUser < ActiveRecord::Base
  #attr_accessible :user, :role

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

