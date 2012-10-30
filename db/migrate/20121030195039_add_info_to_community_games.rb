class AddInfoToCommunityGames < ActiveRecord::Migration
  def change
    add_column :community_games, :info, :hstore
  end
end
