class RemoveIsActiveFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :is_active
  end
end
