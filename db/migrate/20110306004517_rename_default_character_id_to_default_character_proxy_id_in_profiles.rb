class RenameDefaultCharacterIdToDefaultCharacterProxyIdInProfiles < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :default_character_id
    add_column :profiles, :default_character_proxy_id, :integer
  end

  def self.down
    remove_column :profiles, :default_character_proxy_id
    add_column :profiles, :default_character_id, :integer
  end
end
