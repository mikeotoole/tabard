class AddForceLogoutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :force_logout, :boolean, :default => false
  end
end
