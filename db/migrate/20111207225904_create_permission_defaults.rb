class CreatePermissionDefaults < ActiveRecord::Migration
  def change
    create_table :permission_defaults do |t|
      t.integer :role_id
      t.string :object_class
      t.string :permission_level
      t.boolean :can_read, :default => false
      t.boolean :can_update, :default => false
      t.boolean :can_create, :default => false
      t.boolean :can_destroy, :default => false
      t.boolean :can_lock, :default => false
      t.boolean :can_accept, :default => false
      t.string :nested_permission_level
      t.boolean :can_read_nested, :default => false
      t.boolean :can_update_nested, :default => false
      t.boolean :can_create_nested, :default => false
      t.boolean :can_destroy_nested, :default => false
      t.boolean :can_lock_nested, :default => false
      t.boolean :can_accept_nested, :default => false

      t.timestamps
    end
  end
end
