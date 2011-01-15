class AddKeysToDiscussionSpace < ActiveRecord::Migration
  def self.up
    add_column :discussion_spaces, :user_profile_id, :integer
    add_column :discussion_spaces, :game_id, :integer
  end

  def self.down
    remove_column :discussion_spaces, :user_profile_id
    remove_column :discussion_spaces, :game_id
  end
end
