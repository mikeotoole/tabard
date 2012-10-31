class AddInfoIndexToCommunityGames < ActiveRecord::Migration
  def up
    execute "CREATE INDEX community_games_info ON community_games USING GIN(info)"
  end

  def down
    execute "DROP INDEX community_games_info"
  end
end
