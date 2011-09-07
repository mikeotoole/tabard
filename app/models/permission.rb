###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a permission.
###
class Permission < ActiveRecord::Base
###
# Constants
###
  # This is a collection of strings that are valid for subject classes.
  VALID_SUBJECT_CLASSES = %w( Role )
  # This is a collection of strings that are valid for permission levels.
  VALID_PERMISSION_LEVELS = %w( View Update Create Delete )

###
# Associations
###
  belongs_to :role

###
# Validators
###
  validates :role, :presence => true

  validates :subject_class, :presence => true,
      :inclusion => { :in => VALID_SUBJECT_CLASSES, :message => "%{value} is not currently a supported permissionable" }

  validates :permission_level, :inclusion => { :in => VALID_PERMISSION_LEVELS, :message => "%{value} is not a valid permission level" },
      :unless => Proc.new { |permission| permission.permission_level.blank? }


  validate :action_or_permission_level

###
# Delegates
###
  delegate :community_admin_profile_id, :to => :role

###
# Public Methods
###
  def action_or_permission_level
    if !(action.blank? ^ permission_level.blank?)
      self.errors[:base] << "Specify an action or permission level, but not both"
    end
  end
end



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

