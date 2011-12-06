class RenameUsersSuspendedToAdminDisabled < ActiveRecord::Migration
  def change
    rename_column :users, :suspended, :is_admin_disabled
    add_column :users, :is_user_disabled, :boolean, :default => false
    add_column :users, :user_disabled_at, :datetime
    add_column :users, :admin_disabled_at, :datetime
  end
end
