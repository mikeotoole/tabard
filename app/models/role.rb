class Role < ActiveRecord::Base
  attr_accessible :name, :permissions, :roles_users, :users, :permissions, :community
  has_many :roles_users
  has_many :users, :through => :roles_users
  has_many :permissions, :dependent => :destroy
  belongs_to :community
  accepts_nested_attributes_for :permissions
  
  def is_a_member_of(community)
    self.community == community
  end
  
  def is_admin_role?
    self.community.admin_role == self
  end
  
  def is_applicant_role?
    self.community.applicant_role == self
  end
  
  def is_member_role?
    self.community.member_role == self
  end
  
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
  
  def check_user_show_permissions(user)
    user.can_show("Role")
  end
  
  def check_user_create_permissions(user)
    user.can_create("Role") and not self.is_admin_role? and not self.is_applicant_role?
  end
  
  def check_user_update_permissions(user)
    user.can_update("Role") and not self.is_admin_role?
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("Role") and not self.is_admin_role? and not self.is_applicant_role? and not self.is_member_role?
  end
  
  def can_update_users
    not self.is_admin_role? and not self.is_applicant_role? and not self.is_member_role?
  end
end
