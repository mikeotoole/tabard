class Permission < ActiveRecord::Base
  attr_accessible :name, :role, :permissionable, :access, :show_p, :create_p, :update_p, :delete_p, :permission_level
  belongs_to :role
  belongs_to :permissionable, :polymorphic => true
  scope :extra_special_permissions, :conditions => ["access <> ''"]
  
  before_create :check_name_and_create
  
  def magic_polymorphic_helper
    permissionable.id.to_s + "|" + permissionable.class.to_s if permissionable
  end
  
  def magic_polymorphic_helper=(magic_helper)
    return unless not permissionable
    self.permissionable_id = magic_helper.split('|',2)[0]
    self.permissionable_type = magic_helper.split('|',2)[1]
  end
  
  def check_name_and_create
    self.name = self.permissionable_name unless self.name
  end
  
  def role_name
    role != nil ? role.name : ""
  end
  
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
  
  def system_resource_permission
    permissionable.is_a? SystemResource
  end
  
  def check_user_show_permissions(user)
    user.can_show(self.role)
  end
  
  def check_user_create_permissions(user)
    user.can_create(self.role) and not self.role.is_admin_role?
  end
  
  def check_user_update_permissions(user)
    user.can_update(self.role) and not self.role.is_admin_role?
  end
  
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

