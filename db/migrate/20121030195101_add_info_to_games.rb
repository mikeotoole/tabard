class AddInfoToGames < ActiveRecord::Migration
  def change
    add_column :games, :info, :hstore
  end
end
