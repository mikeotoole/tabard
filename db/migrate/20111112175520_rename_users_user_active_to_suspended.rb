class RenameUsersUserActiveToSuspended < ActiveRecord::Migration
  def change
    remove_column :users, :user_active
    add_column :users, :suspended, :boolean, :default => false
  end  
end
