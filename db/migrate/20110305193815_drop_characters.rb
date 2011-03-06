class DropCharacters < ActiveRecord::Migration
  def self.up
    drop_table :characters
  end

  def self.down
      create_table :characters do |t|
        t.integer :game_id
        t.string :name

        t.timestamps
      end
  end
end
