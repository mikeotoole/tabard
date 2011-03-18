class AddDefaultRoleToRole < ActiveRecord::Migration
  def self.up
    add_column :roles, :default_role, :boolean
  end

  def self.down
    remove_column :roles, :default_role
  end
end
