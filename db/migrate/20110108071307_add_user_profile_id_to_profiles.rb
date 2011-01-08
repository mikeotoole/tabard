class AddUserProfileIdToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :user_profile_id, :integer
  end

  def self.down
    remove_column :profiles, :user_profile_id
  end
end
