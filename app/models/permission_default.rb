###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a default for a permission.
###
class PermissionDefault < ActiveRecord::Base
  belongs_to :role, :inverse_of => :permission_defaults

  validates :object_class,  :uniqueness => {:scope => :role_id}

  def is_nested?
    case self.object_class
      when "CustomForm"
        return (not nested_permission_level.blank? or can_read_nested or can_update_nested or can_create_nested or can_destroy_nested or can_lock_nested or can_accept_nested)
      when "DiscussionSpace"
        return (not nested_permission_level.blank? or can_read_nested or can_update_nested or can_create_nested or can_destroy_nested or can_lock_nested or can_accept_nested)
      when "PageSpace"
        return (not nested_permission_level.blank? or can_read_nested or can_update_nested or can_create_nested or can_destroy_nested or can_lock_nested or can_accept_nested)
      else
        return false
    end
  end

  def defined_empty_permission?
    (permission_level.blank? and nested_permission_level.blank? and not can_read and not can_update and not can_create and not can_destroy and not can_lock and not can_accept and not can_read_nested and not can_update_nested and not can_create_nested and not can_destroy_nested and not can_lock_nested and not can_accept_nested)
  end

  def nested_object_class
    case self.object_class
      when "CustomForm"
        return "Submission"
      when "DiscussionSpace"
        return "Discussion"
      when "PageSpace"
        return "Page"
      else
        return ""
    end
  end

  def parent_association_for_subject
    case self.nested_object_class
      when "Submission"
        return "custom_form"
      when "Discussion"
        return "discussion_space"
      when "Page"
        return "page_space"
      else
        return ""
    end
  end
end


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

