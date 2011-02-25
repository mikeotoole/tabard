class Permission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permissionable, :polymorphic => true
  scope :extra_special_permissions, :conditions => ["access <> ''"]
  
  def role_name
    role != nil ? role.name : ""
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
