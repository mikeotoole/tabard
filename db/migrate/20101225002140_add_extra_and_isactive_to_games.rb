class AddExtraAndIsactiveToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :extra, :string
    add_column :games, :is_active, :boolean
  end

  def self.down
    remove_column :games, :type
    remove_column :games, :is_active
  end
end
