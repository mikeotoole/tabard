class AddIsEmailOnAnnouncementToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_email_on_announcement, :boolean, :default => true
  end
end
