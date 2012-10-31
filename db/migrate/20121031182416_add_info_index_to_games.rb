class AddInfoIndexToGames < ActiveRecord::Migration
  def up
    execute "CREATE INDEX games_info ON games USING GIN(info)"
  end

  def down
    execute "DROP INDEX games_info"
  end
end
