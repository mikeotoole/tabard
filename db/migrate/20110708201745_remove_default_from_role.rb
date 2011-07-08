class RemoveDefaultFromRole < ActiveRecord::Migration
  def self.up
    remove_column :roles, :default_role
  end

  def self.down
    add_column :roles, :default_role, :boolean
  end
end
