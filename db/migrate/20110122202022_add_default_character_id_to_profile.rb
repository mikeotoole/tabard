class AddDefaultCharacterIdToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :default_character_id, :integer
  end

  def self.down
    remove_column :profiles, :default_character_id
  end
end
