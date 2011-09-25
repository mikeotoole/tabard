class AddGameAnnouncementSpaceToSupportedGame < ActiveRecord::Migration
  def change
    add_column :supported_games, :game_announcement_space_id, :integer
  end
end
