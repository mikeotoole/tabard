###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a permission.
###
class Permission < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # This is a collection of strings that are valid for subject classes.
  VALID_SUBJECT_CLASSES = %w( Comment CustomForm PageSpace Page DiscussionSpace Discussion CommunityApplication Submission )
  # This is a collection of strings that are valid for parent associations.
  VALID_PARENT_ASSOCIATIONS = %w( discussion_space page_space custom_form )
  # This is a collection of strings that are valid for permission levels.
  VALID_PERMISSION_LEVELS = %w( View Update Create Delete )

###
# Associations
###
  belongs_to :role, :inverse_of => :permissions

###
# Validators
###
  validates :role, :presence => true

  validates :subject_class, :presence => true,
      :inclusion => { :in => VALID_SUBJECT_CLASSES, :message => "%{value} is not currently a supported permissionable" }

  validates :permission_level,
      :inclusion => { :in => VALID_PERMISSION_LEVELS, :message => "%{value} is not a valid permission level" },
      :unless => Proc.new{|permission| permission.permission_level.blank? }

  validates :parent_association_for_subject, :inclusion => { :in => VALID_PARENT_ASSOCIATIONS, :message => "%{value} is not a valid parent."}, :unless => Proc.new { |permission| permission.parent_association_for_subject.blank?}

  validates :id_of_parent, :presence => true, :unless => Proc.new { |permission| permission.parent_association_for_subject.blank?}
  validates :parent_association_for_subject, :presence => true, :unless => Proc.new { |permission| permission.id_of_parent.blank?}

  validate :only_subject_id_if_not_nested

  validate :only_booleans_or_permission_level

###
# Delegates
###
  delegate :community_admin_profile_id, :to => :role

###
# Public Methods
###
  # This method ensure that the subject id is only added if it is not nested.
  def only_subject_id_if_not_nested
    errors.add(:base, "You can not have both id_of_subject and parent_association_for_subject/id_of_parent") if (not self.id_of_subject.blank?) and ((not self.id_of_parent.blank?) or (not self.parent_association_for_subject.blank?))
  end

  # This method ensures that only booleans or the permission level string are set.
  def only_booleans_or_permission_level
    errors.add(:base, "You can not have both permission_level and hand picked permissions") if (not self.permission_level.blank?) and (self.can_read or self.can_update or self.can_create or self.can_destroy)
  end

  # This method gets the label for this permission to display to the user.
  def label
    case self.subject_class
      when "DiscussionSpace"
        if self.id_of_subject
          dspace = DiscussionSpace.find_by_id(self.id_of_subject)
          return (dspace ? dspace.name : "Unknown")
        else
          return "All Discussion Spaces"
        end
      when "Discussion"
        if self.id_of_subject
          disc = Discussion.find_by_id(self.id_of_subject)
          return (disc ? disc.name : "Unknown")
        else
          if self.id_of_parent
            dspace = DiscussionSpace.find_by_id(self.id_of_parent)
            return (dspace ? "Discussions in #{dspace.name}" : "Unknown")
          else
            return "All Discussions"
          end
        end
      else
        return self.subject_class
    end
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
#  id_of_subject                  :integer(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#  can_lock                       :boolean         default(FALSE)
#  can_accept                     :boolean         default(FALSE)
#  parent_association_for_subject :string(255)
#  id_of_parent                   :integer
#  deleted_at                     :datetime
#  can_read                       :boolean         default(FALSE)
#  can_create                     :boolean         default(FALSE)
#  can_update                     :boolean         default(FALSE)
#  can_destroy                    :boolean         default(FALSE)
#

