class AddCommunityGameIdToPageSpaces < ActiveRecord::Migration
  def change
    add_column :page_spaces, :community_game_id, :integer
  end
end
