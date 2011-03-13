class CorrectDiscussionForUserProfile < ActiveRecord::Migration
  def self.up
    rename_column :profiles, :discussion_space_id, :discussion_id
  end

  def self.down
    rename_column :profiles, :discussion_id, :discussion_space_id
  end
end
