class AddAnnouncementSpaceToDiscussionSpaces < ActiveRecord::Migration
  def self.up
    add_column :discussion_spaces, :announcement_space, :boolean
  end

  def self.down
    remove_column :discussion_spaces, :announcement_space
  end
end
