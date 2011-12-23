class AddEnhancedPermissionFieldsToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :can_read, :boolean, :default => false
    add_column :permissions, :can_create, :boolean, :default => false
    add_column :permissions, :can_update, :boolean, :default => false
    add_column :permissions, :can_destroy, :boolean, :default => false
  end
end
