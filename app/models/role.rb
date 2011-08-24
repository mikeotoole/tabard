=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a role.
=end
class Role < ActiveRecord::Base

=begin
  This class is an exception class that is raised if permissions are added or removed from a admin or applicant role.
=end
  class SystemUserPermissionAssociactionLocked < StandardError; end
  #attr_accessible :name, :description, :permissions, :roles_users, :users, :permissions_attributes, :community

  has_many :roles_users
  has_many :users, :through => :roles_users
  has_many :permissions, :dependent => :destroy,
    :before_add    => :ensure_system_role_association_rules,
    :before_remove => :ensure_system_role_association_rules

  belongs_to :community

  accepts_nested_attributes_for :permissions

  validate :name, :presence => true
  validate :ensure_system_role_rules

=begin
  This method ensures that system roles can't be modified.
  [Returns] True is successful, otherwise false.
=end
  def ensure_system_role_rules
    return true unless self.is_system_role? and not self.new_record?
    if self.name_changed?
      self.errors[:name] << "You can't change the name for a system role."
      self.name = self.name_was
    end
    if self.description_changed?
      self.errors[:description] << "You can't change the description for a system role."
      self.description = self.description_was
    end
  end

=begin
  _before_add_permissions_

  _before_remove_permissions_

  This method ensures that system roles permissions can't be added or removed.
  [Raises]
    * +SystemUserPermissionAssociactionLocked+ -> if this role is an admin
=end
  def ensure_system_role_association_rules(permission)
    return true unless (self.is_admin_role? or self.is_applicant_role?) and not self.new_record?
    self.errors[:permissions] << "You can't change the permissions for admin role."
    raise SystemUserPermissionAssociactionLocked
  end

=begin
  This method determines if this role is a part of the given community.
  [Args]
    * +community+ -> The community to use.
  [Returns] True if this role is a member of the community, otherwise false.
=end
  def is_a_member_of(community)
    self.community == community
  end

=begin
  This method checks to see if this role is the admin role of a community.
  [Returns] True is this role is the admin role, otherwise false.
=end
  def is_admin_role?
    self.community.admin_role == self if self.community
  end

=begin
  This method checks to see if this role is the applicant role of a community.
  [Returns] True is this role is the applicant role, otherwise false.
=end
  def is_applicant_role?
    self.community.applicant_role == self if self.community
  end

=begin
  This method checks to see if this role is the member role of a community.
  [Returns] True is this role is the member role, otherwise false.
=end
  def is_member_role?
    self.community.member_role == self if self.community
  end

=begin
  This method checks to see if this role is a system role of a community.
  [Returns] True is this role is the system role, otherwise false.
=end
  def is_system_role?
    self.community.admin_role == self or
    self.community.applicant_role == self or
    self.community.member_role == self
  end

=begin
  This method gets all permissions of this role who have show permissions.
  [Returns] An array of all permissions of this role who have show permissions.
=end
  def show_permissions
    permissions.where(:show_p => true)
  end

=begin
  This method gets all permissions of this role who have create permissions.
  [Returns] An array of all permissions of this role who have create permissions.
=end
  def create_permissions
    permissions.where(:create_p => true)
  end

=begin
  This method gets all permissions of this role who have update permissions.
  [Returns] An array of all permissions of this role who have update permissions.
=end
  def update_permissions
    permissions.where(:update_p => true)
  end

=begin
  This method gets all permissions of this role who have delete permissions.
  [Returns] An array of all permissions of this role who have delete permissions.
=end
  def delete_permissions
    permissions.where(:delete_p => true)
  end

=begin
  This method gets all permissionables from permissions of this role who have show permissions.
  [Returns] An array of all permissionables from permissions of this role who have show permissions.
=end
  def show_permissionables
    permissions.where(:show_p => true).collect {|a| a.permissionable}
  end

=begin
  This method gets all permissionables from permissions of this role who have create permissions.
  [Returns] An array of all permissionables from permissions of this role who have create permissions.
=end
  def create_permissionables
    permissions.where(:create_p => true).collect {|a| a.permissionable}
  end

=begin
  This method gets all permissionables from permissions of this role who have update permissions.
  [Returns] An array of all permissionables from permissions of this role who have update permissions.
=end
  def update_permissionables
    permissions.where(:update_p => true).collect {|a| a.permissionable}
  end

=begin
  This method gets all permissionables from permissions of this role who have delete permissions.
  [Returns] An array of all permissionables from permissions of this role who have delete permissions.
=end
  def delete_permissionables
    permissions.where(:delete_p => true).collect {|a| a.permissionable}
  end

=begin
  This method gets all permissionables from permissions of this role who have special permissions.
  [Returns] An array of all permissionables from permissions of this role who have special permissions.
=end
  def special_permissionables
    permissions.extra_special_permissions
  end

=begin
  This method gets all system resource of this role who have show permissions.
  [Returns] An array of all system resource of this role who have show permissions.
=end
  def show_system_resources
    show_permissions.keep_if {|p| p.system_resource_permission}
  end

=begin
  This method gets all system resource of this role who have create permissions.
  [Returns] An array of all system resource of this role who have create permissions.
=end
  def create_system_resources
    create_permissions.keep_if {|p| p.system_resource_permission}
  end

=begin
  This method gets all system resource of this role who have update permissions.
  [Returns] An array of all system resource of this role who have update permissions.
=end
  def update_system_resources
    update_permissions.keep_if {|p| p.system_resource_permission}
  end

=begin
  This method gets all system resource of this role who have delete permissions.
  [Returns] An array of all system resource of this role who have delete permissions.
=end
  def delete_system_resources
    delete_permissions.keep_if {|p| p.system_resource_permission}
  end

=begin
  This method defines how show permissions are determined for this role.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this role, otherwise false.
=end
  def check_user_show_permissions(user)
    user.can_show("Role")
  end

=begin
  This method defines how create permissions are determined for this role.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this role, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create("Role") and not self.is_admin_role? and not self.is_applicant_role?
  end

=begin
  This method defines how update permissions are determined for this role.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this role, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update("Role") and not self.is_admin_role?
  end

=begin
  This method defines how delete permissions are determined for this role.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this role, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("Role") and not self.is_admin_role? and not self.is_applicant_role? and not self.is_member_role?
  end

  def can_update_users
    not self.is_admin_role? and not self.is_applicant_role? and not self.is_member_role?
  end
end

# == Schema Information
#
# Table name: roles
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  community_id :integer
#  description  :string(255)
#

