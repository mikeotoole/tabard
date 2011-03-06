class RemoveGameIdFromCharacters < ActiveRecord::Migration
  def self.up
    remove_column :wow_characters, :game_id
    remove_column :swtor_characters, :game_id
  end

  def self.down
    add_column :wow_characters, :game_id, :integer
    add_column :swtor_characters, :game_id, :integer
  end
end
