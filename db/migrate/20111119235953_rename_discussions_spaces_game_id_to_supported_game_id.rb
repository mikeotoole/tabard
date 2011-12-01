class RenameDiscussionsSpacesGameIdToSupportedGameId < ActiveRecord::Migration
  def change
    rename_column(:discussion_spaces, :game_id, :supported_game_id)
  end
end
