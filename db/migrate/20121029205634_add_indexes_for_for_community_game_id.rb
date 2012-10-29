class AddIndexesForForCommunityGameId < ActiveRecord::Migration
  def change
    add_index :community_games, :community_id
    add_index :community_games, :game_id
    add_index :community_games, :game_announcement_space_id
  end
end
