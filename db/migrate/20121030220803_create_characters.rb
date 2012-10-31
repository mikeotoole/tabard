class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :avatar
      t.text :about
      t.integer :played_game_id
      t.hstore :info
      t.string :type

      t.timestamps
    end
  end
end
