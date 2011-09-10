class CreateSwtorCharacters < ActiveRecord::Migration
  def change
    create_table :swtor_characters do |t|
      t.string :name
      t.string :server
      t.integer :game_id
      t.string :avatar

      t.timestamps
    end
  end
end
