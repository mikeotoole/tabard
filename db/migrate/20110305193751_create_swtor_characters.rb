class CreateSwtorCharacters < ActiveRecord::Migration
  def self.up
    create_table :swtor_characters do |t|
      t.integer :game_id
      t.string :name
      t.string :server

      t.timestamps
    end
  end

  def self.down
    drop_table :swtor_characters
  end
end
