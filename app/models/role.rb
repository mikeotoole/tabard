###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a role.
###
class Role < ActiveRecord::Base
###
# Associations
###
  belongs_to :community
  has_many :permissions, :inverse_of => :role
  has_many :permission_defaults, :inverse_of => :role
  has_and_belongs_to_many :community_profiles
  has_many :user_profiles, :through => :community_profiles
  accepts_nested_attributes_for :permission_defaults, :allow_destroy => true
  accepts_nested_attributes_for :permissions, :allow_destroy => true

###
# Validators
###
  validates :community, :presence => true
  validates :name,  :uniqueness => {:scope => :community_id}, 
                    :length => { :maximum => 100 }

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true

  after_create :setup_permission_defaults

  def permissions_for_resource(resource)
    if resource.is_a?(String)
      permission_match = self.permissions.find_by_subject_class_and_id_of_subject(resource,nil)
      return permission_match ? permission_match : Permission.new(role: self, subject_class: resource.to_s)
    else
      permission_match = self.permissions.find_by_subject_class_and_id_of_subject(resource.class.to_s,resource.id)
      return permission_match ? permission_match : Permission.new(role: self, subject_class: resource.class, id_of_subject: resource.id)
    end
  end
  def nested_permissions_for_resource(resource)
    case resource.class.to_s
      when "DiscussionSpace"
        permission_match = self.permissions.find_by_subject_class_and_id_of_parent("Discussion",resource.id)
        return permission_match ? permission_match : Permission.new(role: self, subject_class: "Discussion", parent_association_for_subject: "discussion_space", id_of_parent: resource.id)
      when "PageSpace"
        permission_match = self.permissions.find_by_subject_class_and_id_of_parent("Page",resource.id)
        return permission_match ? permission_match : Permission.new(role: self, subject_class: "Page", parent_association_for_subject: "page_space", id_of_parent: resource.id)
      when "CustomForm"
        permission_match = self.permissions.find_by_subject_class_and_id_of_parent("Submission",resource.id)
        return permission_match ? permission_match : Permission.new(role: self, subject_class: "Submission", parent_association_for_subject: "custom_form", id_of_parent: resource.id)
      else
        return nil
    end
  end

  def is_member_role?
    self.community.member_role.id == self.id
  end

  def setup_permission_defaults
    self.permission_defaults.create(object_class: "CustomForm",
      permission_level: "View", 
      can_lock: false, 
      can_accept: false,
      can_read_nested: false, 
      can_update_nested: false, 
      can_create_nested: false, 
      can_destroy_nested: false, 
      can_lock_nested: false, 
      can_accept_nested: false)
    self.permission_defaults.create(object_class: "DiscussionSpace",
      permission_level: "View", 
      can_lock: false, 
      can_accept: false,
      can_read_nested: false, 
      can_update_nested: false, 
      can_create_nested: true, 
      can_destroy_nested: false, 
      can_lock_nested: false, 
      can_accept_nested: false)
    self.permission_defaults.create(object_class: "PageSpace",
      permission_level: "View", 
      can_lock: false, 
      can_accept: false,
      nested_permission_level: "", 
      can_lock_nested: false, 
      can_accept_nested: false)
  end

  def apply_default_permissions(some_thing)
    template = self.permission_defaults.find_by_object_class(some_thing.class.to_s)
    return unless template and some_thing.persisted?
    if template.permission_level.blank?
      self.permissions.create(subject_class: template.object_class, 
        id_of_subject: some_thing.id, 
        can_read: template.can_read, 
        can_update: template.can_update, 
        can_create: template.can_create, 
        can_destroy: template.can_destroy, 
        can_lock: template.can_lock, 
        can_accept: template.can_accept)
    else
      self.permissions.create(subject_class: template.object_class, 
        id_of_subject: some_thing.id, 
        permission_level: template.permission_level, 
        can_lock: template.can_lock, 
        can_accept: template.can_accept)
    end
    if template.is_nested?
      if template.nested_permission_level.blank?
        self.permissions.create(subject_class: template.nested_object_class, 
          parent_association_for_subject: template.parent_association_for_subject, 
          id_of_parent: some_thing.id, 
          can_read: template.can_read_nested, 
          can_update: template.can_update_nested, 
          can_create: template.can_create_nested, 
          can_destroy: template.can_destroy_nested, 
          can_lock: template.can_lock_nested, 
          can_accept: template.can_accept_nested)
      else
        self.permissions.create(subject_class: template.nested_object_class, 
          parent_association_for_subject: template.parent_association_for_subject, 
          id_of_parent: some_thing.id, 
          permission_level: template.nested_permission_level, 
          can_lock: template.can_lock_nested, 
          can_accept: template.can_accept_nested)
      end
    end
  end
end


# == Schema Information
#
# Table name: roles
#
#  id                  :integer         not null, primary key
#  community_id        :integer
#  name                :string(255)
#  is_system_generated :boolean         default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

