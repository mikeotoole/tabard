class AddIndexesToSupportedGames < ActiveRecord::Migration
  def change
    add_index :supported_games, :community_id
    add_index :supported_games, :game_id
  end
end
