class RemoveIsDefaultCharacterFromCharacterProxy < ActiveRecord::Migration
  def up
    remove_column(:character_proxies, :is_default_character)
  end

  def down
    add_column(:character_proxies, :is_default_character, :boolean, default: false)
  end
end
