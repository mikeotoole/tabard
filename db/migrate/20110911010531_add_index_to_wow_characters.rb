class AddIndexToWowCharacters < ActiveRecord::Migration
  def change
    add_index :wow_characters, :game_id
  end
end
