class AddIsEmailOnMessageToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :is_email_on_message, :boolean, :default => true
  end
end
