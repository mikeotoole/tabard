class MakeAdminUserLockable < ActiveRecord::Migration
  change_table(:admin_users) do |t|
    #t.lockable lock_strategy: :failed_attempts, unlock_strategy: :both
    t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
    t.string   :unlock_token # Only if unlock strategy is :email or :both
    t.datetime :locked_at
  end
end
