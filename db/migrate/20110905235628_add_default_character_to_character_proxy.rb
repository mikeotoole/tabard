class AddDefaultCharacterToCharacterProxy < ActiveRecord::Migration
  def change
    add_column :character_proxies, :is_default_character, :boolean, default: true
  end
end
