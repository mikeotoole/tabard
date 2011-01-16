class Permission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permissionable, :polymorphic => true
  
  def role_name
    role != nil ? role.name : ""
  end
  
  def permissionable_name
    if permissionable.is_a?(SystemResource)
      return permissionable.name
    end
    "unknown"
  end
  
  def system_resource_permission
    permissionable.is_a? SystemResource
  end
end
