class RenameUserProfileIsToAuthorIdInMessages < ActiveRecord::Migration
  def self.up
    rename_column :messages, :user_profile_id, :author_id
  end

  def self.down
    rename_column :messages, :author_id, :user_profile_id
  end
end
