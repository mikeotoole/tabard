class RenameUserProfileIsToRecipientIdInMessageCopies < ActiveRecord::Migration
  def self.up
    rename_column :message_copies, :user_profile_id, :recipient_id
  end

  def self.down
    rename_column :message_copies, :recipient_id, :user_profile_id
  end
end
