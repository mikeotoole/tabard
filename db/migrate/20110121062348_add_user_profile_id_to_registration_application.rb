class AddUserProfileIdToRegistrationApplication < ActiveRecord::Migration
  def self.up
    add_column :registration_applications, :user_profile_id, :integer
  end

  def self.down
    remove_column :registration_applications, :user_profile_id
  end
end
