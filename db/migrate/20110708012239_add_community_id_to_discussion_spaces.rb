class AddCommunityIdToDiscussionSpaces < ActiveRecord::Migration
  def self.up
    add_column :discussion_spaces, :community_id, :integer
  end

  def self.down
    remove_column :discussion_spaces, :community_id
  end
end
