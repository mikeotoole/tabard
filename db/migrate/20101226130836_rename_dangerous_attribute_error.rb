class RenameDangerousAttributeError < ActiveRecord::Migration
  def self.up
    rename_column :permissions, :show, :show_p
    rename_column :permissions, :create, :create_p
    rename_column :permissions, :update, :update_p
    rename_column :permissions, :delete, :delete_p
  end

  def self.down
    rename_column :permissions, :show_p, :show
    rename_column :permissions, :create_p, :create
    rename_column :permissions, :update_p, :update
    rename_column :permissions, :delete_p, :delete
  end
end
