class AddGameIdToPageSpaces < ActiveRecord::Migration
  def self.up
    add_column :page_spaces, :game_id, :intager
  end

  def self.down
    remove_column :page_spaces, :game_id
  end
end
