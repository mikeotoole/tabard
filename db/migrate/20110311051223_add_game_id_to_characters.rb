class AddGameIdToCharacters < ActiveRecord::Migration
  def self.up
    add_column :wow_characters, :game_id, :integer
    add_column :swtor_characters, :game_id, :integer
  end

  def self.down
    remove_column :wow_characters, :game_id
    remove_column :swtor_characters, :game_id
  end
end
