class CreateCharacterProxies < ActiveRecord::Migration
  def self.up
    create_table :character_proxies do |t|
      t.integer :game_profile_id
      t.integer :character_id
      t.string :character_type

      t.timestamps
    end
  end

  def self.down
    drop_table :character_proxies
  end
end
