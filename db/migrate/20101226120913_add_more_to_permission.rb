class AddMoreToPermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :show, :boolean
    add_column :permissions, :create, :boolean
    add_column :permissions, :update, :boolean
    add_column :permissions, :delete, :boolean
  end

  def self.down
    remove_column :permissions, :show
    remove_column :permissions, :create
    remove_column :permissions, :update
    remove_column :permissions, :delete
  end
end
