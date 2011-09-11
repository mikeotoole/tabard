class AddIndexToSwtorCharacters < ActiveRecord::Migration
  def change
    add_index :swtor_characters, :game_id
  end
end
