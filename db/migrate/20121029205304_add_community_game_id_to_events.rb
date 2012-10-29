class AddCommunityGameIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :community_game_id, :integer
  end
end
