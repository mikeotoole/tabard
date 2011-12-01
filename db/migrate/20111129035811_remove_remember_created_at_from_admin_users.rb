class RemoveRememberCreatedAtFromAdminUsers < ActiveRecord::Migration
  def up
    remove_column(:admin_users, :remember_created_at)
  end

  def down
    change_table(:admin_users) do |t|
      t.rememberable
    end
  end
end
