class Role < ActiveRecord::Base
  has_many :roles_users
  has_many :users, :through => :roles_users
  has_many :permissions, :dependent => :destroy
  accepts_nested_attributes_for :permissions
  
  def show_permissions
    permissions.where(:show_p => true)
  end
  
  def create_permissions
    permissions.where(:create_p => true)
  end
  
  def update_permissions
    permissions.where(:update_p => true)
  end
  
  def delete_permissions
    permissions.where(:delete_p => true)
  end
  def show_permissionables
    permissions.where(:show_p => true).collect {|a| a.permissionable}
  end
  
  def create_permissionables
    permissions.where(:create_p => true).collect {|a| a.permissionable}
  end
  
  def update_permissionables
    permissions.where(:update_p => true).collect {|a| a.permissionable}
  end
  
  def delete_permissionables
    permissions.where(:delete_p => true).collect {|a| a.permissionable}
  end
  
  def special_permissionables
    permissions.extra_special_permissions
  end
  
  def show_system_resources
    show_permissions.keep_if {|p| p.system_resource_permission}
  end
  
  def create_system_resources
    create_permissions.keep_if {|p| p.system_resource_permission}
  end
  
  def update_system_resources
    update_permissions.keep_if {|p| p.system_resource_permission}
  end
  
  def delete_system_resources
    delete_permissions.keep_if {|p| p.system_resource_permission}
  end
end
