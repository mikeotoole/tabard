class AddIndexForCharacterProxies < ActiveRecord::Migration
  def change
    add_index :character_proxies, :user_profile_id
    add_index :character_proxies, [:character_type, :character_id], name: 'index_proxies_on_character_type_and_character_id'
  end
end
