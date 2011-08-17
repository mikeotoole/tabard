=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a permission.
=end
class Permission < ActiveRecord::Base
  #attr_accessible :name, :role, :permissionable, :access, :show_p, :create_p, :update_p, :delete_p, :permission_level
  
  belongs_to :role
  belongs_to :permissionable, :polymorphic => true
  scope :extra_special_permissions, :conditions => ["access <> ''"]
  
  before_create :check_name_and_create
  
  validate :ensure_system_role_association_rules
  
=begin
  This method gets the magic polymorphic helper.
  [Returns] A string that contains the permissionable id + | + the permissionable class.
=end
  def magic_polymorphic_helper
    permissionable.id.to_s + "|" + permissionable.class.to_s if permissionable
  end

=begin
  This method sets the magic polymorphic helper.
  [Args]
    * +magic_helper+ -> A string that contains the helper you would like to use.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def magic_polymorphic_helper=(magic_helper)
    return unless not permissionable
    self.permissionable_id = magic_helper.split('|',2)[0]
    self.permissionable_type = magic_helper.split('|',2)[1]
  end
  
=begin
  _before_create_
  
  This method ensures that this permission always has a name.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def check_name_and_create
    self.name = self.permissionable_name unless self.name
  end
  
=begin
  This method ensures that this permission is not changing the admin system role.
  [Returns] True if the is permission is valid, otherwise false.
=end
  def ensure_system_role_association_rules
    return true unless not self.new_record? and self.role and self.role.is_admin_role? and self.role.is_applicant_role?
    self.errors[:base] << "You can't change the permissions for admin role."
  end
  
=begin
  This method gets the name of the role this permission is belongs to.
  [Returns] A string that contains the name of the role this permission belongs to, if possible, otherwise it returns an empty string.
=end
  def role_name
    role != nil ? role.name : ""
  end
  
=begin
  This method gets permission level of this permission.
  [Returns] A string that contains permission level of this permission, if possible, otherwise it returns an empty string.
=end
  def permission_level
    if self.delete_p
      return 'delete_p'
    elsif self.create_p
      return 'create_p'
    elsif self.update_p
      return 'update_p'
    elsif self.show_p
      return 'show_p'
    else
      return ''
    end
  end
  
=begin
  This method sets permission level of this permission.
  [Args]
    * +value+ -> A string that contains the permission level you would like to use.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def permission_level=(value)
    case value
      when 'delete_p'
        self.update_p = true
        self.create_p = true
        self.delete_p = true
        self.show_p = true
      when 'create_p'    
        self.delete_p = false
        self.update_p = true
        self.create_p = true
        self.show_p = true
      when 'update_p'
        self.delete_p = false
        self.update_p = true
        self.create_p = false
        self.show_p = true
      else
        self.delete_p = false
        self.update_p = false
        self.create_p = false
        self.show_p = true
    end
  end
  
=begin
  This method gets the name of the item this permission is for.
  [Returns] A string that contains the name of the item that this permission is for, otherwise a string that contains "unknown".
=end
  def permissionable_name
    if permissionable.is_a?(SystemResource)
      return permissionable.name
    else 
      if permissionable.respond_to?('name')
        return (permissionable.class.to_s + " | " + permissionable.name.to_s)
      end
    end
    "unknown"
  end
  
=begin
  This method determines if this is a permission on a system resource.
  [Returns] True if permissionable item for this permission is a system resource, otherwise false.
=end
  def system_resource_permission
    permissionable.is_a? SystemResource
  end
  
=begin
  This method defines how show permissions are determined for this permission.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this permission, otherwise false.
=end
  def check_user_show_permissions(user)
    user.can_show(self.role)
  end
  
=begin
  This method defines how create permissions are determined for this permission.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this permission, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create(self.role) and not self.role.is_admin_role?
  end
  
=begin
  This method defines how update permissions are determined for this permission.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this permission, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update(self.role) and not self.role.is_admin_role?
  end
  
=begin
  This method defines how delete permissions are determined for this permission.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this permission, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("Role") and not self.role.is_admin_role?
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  role_id             :integer
#  created_at          :datetime
#  updated_at          :datetime
#  permissionable_id   :integer
#  permissionable_type :string(255)
#  access              :string(255)
#  show_p              :boolean
#  create_p            :boolean
#  update_p            :boolean
#  delete_p            :boolean
#

