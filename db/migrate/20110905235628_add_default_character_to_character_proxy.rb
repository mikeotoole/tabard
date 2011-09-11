class AddDefaultCharacterToCharacterProxy < ActiveRecord::Migration
  def change
    add_column :character_proxies, :default_character, :boolean, :default => true
    remove_column :character_proxies, :default
  end
end
