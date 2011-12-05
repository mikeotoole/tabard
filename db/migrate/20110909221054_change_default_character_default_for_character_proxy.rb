class ChangeDefaultCharacterDefaultForCharacterProxy < ActiveRecord::Migration
  def up
    change_column_default(:character_proxies, :is_default_character, false)
  end

  def down
    change_column_default(:character_proxies, :is_default_character, true)
  end
end
