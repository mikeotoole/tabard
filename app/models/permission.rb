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
  VALID_SUBJECT_CLASSES = %w( Role CustomForm PageSpace Page DiscussionSpace Discussion Announcement CommunityApplication )
  # This is a collection of strings that are valid for parent associations.
  VALID_PARENT_ASSOCIATIONS = %w( discussion_space page_space )
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

  validates :permission_level, :presence => true,
      :inclusion => { :in => VALID_PERMISSION_LEVELS, :message => "%{value} is not a valid permission level" }

  validates :parent_association_for_subject, :inclusion => { :in => VALID_PARENT_ASSOCIATIONS, :message => "%{value} is not a valid parent."}, :unless => Proc.new { |permission| permission.parent_association_for_subject.blank?}

  validates :id_of_parent, :presence => true, :unless => Proc.new { |permission| permission.parent_association_for_subject.blank?}
  validates :parent_association_for_subject, :presence => true, :unless => Proc.new { |permission| permission.id_of_parent.blank?}

  validate :only_subject_id_if_not_nested

###
# Delegates
###
  delegate :community_admin_profile_id, :to => :role

###
# Public Methods
###
  def only_subject_id_if_not_nested
    errors.add(:base, "You can not have both id_of_subject and parent_association_for_subject/id_of_parent") if (not self.id_of_subject.blank?) and ((not self.id_of_parent.blank?) or (not self.parent_association_for_subject.blank?))
  end
end









# == Schema Information
#
# Table name: permissions
#
#  id                             :integer         not null, primary key
#  role_id                        :integer
#  permission_level               :string(255)
#  subject_class                  :string(255)
#  id_of_subject                  :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#  can_lock                       :boolean         default(FALSE)
#  can_accept                     :boolean         default(FALSE)
#  parent_association_for_subject :string(255)
#  id_of_parent                   :integer
#

