class AddIsEmailOnAnnouncementToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :is_email_on_announcement, :boolean, :default => true
  end
end
