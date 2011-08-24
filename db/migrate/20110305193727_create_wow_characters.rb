class CreateWowCharacters < ActiveRecord::Migration
  def self.up
    create_table :wow_characters do |t|
      t.integer :game_id
      t.string :name
      t.string :faction
      t.string :race
      t.string :class
      t.integer :level
      t.string :server

      t.timestamps
    end
  end

  def self.down
    drop_table :wow_characters
  end
end
