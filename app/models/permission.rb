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
end
