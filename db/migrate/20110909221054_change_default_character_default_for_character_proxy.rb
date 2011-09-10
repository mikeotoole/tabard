class ChangeDefaultCharacterDefaultForCharacterProxy < ActiveRecord::Migration
  def up
    change_column_default(:character_proxies, :default_character, false)
  end

  def down
    change_column_default(:character_proxies, :default_character, true)
  end
end
