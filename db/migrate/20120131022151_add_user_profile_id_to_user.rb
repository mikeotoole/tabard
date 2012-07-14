class AddUserProfileIdToUser < ActiveRecord::Migration
  def up
    remove_index :user_profiles, :user_id
    remove_column :user_profiles, :user_id
    add_column :users, :user_profile_id, :integer
    add_index :users, :user_profile_id, unique: true
  end

  def down
    remove_index :users, :user_profile_id
    remove_column :users, :user_profile_id
    add_column :user_profiles, :user_id, :integer
    add_index :user_profiles, :user_id, unique: true
  end
end