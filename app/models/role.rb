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
  has_many :permissions
  has_and_belongs_to_many :community_profiles
  has_many :user_profiles, :through => :community_profiles
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

