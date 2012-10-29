class AddCommunityGameIdToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :community_game_id, :integer
  end
end
