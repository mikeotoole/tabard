class UpdateSupportedGamesGameIndexForGameType < ActiveRecord::Migration
  def up
    remove_index :supported_games, :game_id
    add_index :supported_games, [:game_id, :game_type]
  end

  def down
    remove_index :supported_games, [:game_id, :game_type]
    add_index :supported_games, :game_id
  end
end
