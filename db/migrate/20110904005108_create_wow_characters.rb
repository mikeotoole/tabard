class CreateWowCharacters < ActiveRecord::Migration
  def change
    create_table :wow_characters do |t|
      t.string :name
      t.string :faction
      t.string :race
      t.integer :level
      t.string :server
      t.integer :game_id
      t.string :avatar

      t.timestamps
    end
  end
end
