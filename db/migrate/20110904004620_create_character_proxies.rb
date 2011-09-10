class CreateCharacterProxies < ActiveRecord::Migration
  def change
    create_table :character_proxies do |t|
      t.integer :user_profile_id
      t.integer :character_id
      t.string :character_type

      t.timestamps
    end
  end
end
