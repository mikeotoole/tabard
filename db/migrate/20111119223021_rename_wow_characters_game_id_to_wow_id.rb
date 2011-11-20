class RenameWowCharactersGameIdToWowId < ActiveRecord::Migration
  def up
    remove_column(:wow_characters, :server)
    remove_column(:wow_characters, :faction)
    rename_column(:wow_characters, :game_id, :wow_id)
  end
  
  def down
    add_column(:wow_characters, :server, :string)
    add_column(:wow_characters, :faction, :string)
    rename_column(:wow_characters, :wow_id, :game_id)
  end   
end
