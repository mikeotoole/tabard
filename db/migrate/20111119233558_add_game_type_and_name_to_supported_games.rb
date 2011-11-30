class AddGameTypeAndNameToSupportedGames < ActiveRecord::Migration
  def change
    add_column(:supported_games, :name, :string)
    add_column(:supported_games, :game_type, :string)
  end
end
