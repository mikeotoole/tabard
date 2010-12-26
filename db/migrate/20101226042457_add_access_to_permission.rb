class AddAccessToPermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :access, :string
  end

  def self.down
    remove_column :permissions, :access
  end
end
