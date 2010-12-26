class AddMissingAssociationColumnsForPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :permissionable_id, :integer
    add_column :permissions, :permissionable_type, :string
  end

  def self.down
    remove_column :permissions, :permissionable_id
    remove_column :permissions, :permissionable_type
  end
end
