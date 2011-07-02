class AddGameIdToPageSpaces < ActiveRecord::Migration
  def self.up
    add_column :page_spaces, :game_id, :integer
  end

  def self.down
    remove_column :page_spaces, :game_id
  end
end
