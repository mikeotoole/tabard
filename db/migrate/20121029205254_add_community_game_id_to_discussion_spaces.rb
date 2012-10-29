class AddCommunityGameIdToDiscussionSpaces < ActiveRecord::Migration
  def change
    add_column :discussion_spaces, :community_game_id, :integer
  end
end
