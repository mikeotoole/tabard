class MakeAdminUserLockable < ActiveRecord::Migration
  change_table(:admin_users) do |t|
    t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
  end
end
