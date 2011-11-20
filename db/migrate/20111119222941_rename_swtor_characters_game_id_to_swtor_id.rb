class RenameSwtorCharactersGameIdToSwtorId < ActiveRecord::Migration
  def up
    remove_column(:swtor_characters, :server)
    rename_column(:swtor_characters, :game_id, :swtor_id)
  end
  
  def down
    add_column(:swtor_characters, :server, :string)
    rename_column(:swtor_characters, :swtor_id, :game_id)
  end 
end
