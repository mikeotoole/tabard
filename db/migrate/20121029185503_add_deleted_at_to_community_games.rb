class AddDeletedAtToCommunityGames < ActiveRecord::Migration
  def change
    add_column :community_games, :deleted_at, :datetime
  end
end
