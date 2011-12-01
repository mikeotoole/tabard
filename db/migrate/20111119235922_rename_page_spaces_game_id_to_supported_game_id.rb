class RenamePageSpacesGameIdToSupportedGameId < ActiveRecord::Migration
  def change
    rename_column(:page_spaces, :game_id, :supported_game_id)
  end
end
