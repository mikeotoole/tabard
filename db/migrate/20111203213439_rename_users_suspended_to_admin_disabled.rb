class RenameUsersSuspendedToAdminDisabled < ActiveRecord::Migration
  def change
    remove_column :users, :suspended
    add_column :users, :user_disabled_at, :datetime
    add_column :users, :admin_disabled_at, :datetime
  end
end
