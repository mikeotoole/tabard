class AddGameProfileIdToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :game_profile_id, :integer
  end

  def self.down
    remove_column :characters, :game_profile_id
  end
end
