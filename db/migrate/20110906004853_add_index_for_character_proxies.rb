class AddIndexForCharacterProxies < ActiveRecord::Migration
  def up
    add_index :character_proxies, :user_profile_id
    add_index :character_proxies, [:character_type, :character_id]
  end

  def down
    remove_index :user_profile_id
    remove_index [:character_type, :character_id]
  end
end
