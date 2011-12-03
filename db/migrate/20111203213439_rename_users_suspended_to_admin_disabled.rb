class RenameUsersSuspendedToAdminDisabled < ActiveRecord::Migration
  def change
    rename_column :users, :suspended, :admin_disabled
    add_column :users, :user_disabled, :boolean, :default => false
    add_column :users, :user_disabled_at, :datetime
    add_column :users, :admin_disabled_at, :datetime
  end
end
