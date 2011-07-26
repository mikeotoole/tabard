class Permission < ActiveRecord::Base
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
      permission_level = 'delete_p'
    elsif self.create_p
      permission_level = 'create_p'
    elsif self.update_p
      permission_level = 'update_p'
    elsif self.show_p
      permission_level = 'show_p'
    else
      permission_level = ''
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
end
