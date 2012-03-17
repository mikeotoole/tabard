class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :body
      t.datetime :start_time
      t.datetime :end_time
      t.integer :creator_id
      t.integer :supported_game_id
      t.integer :community_id
      t.boolean :is_public, :default => false
      t.string :location

      t.timestamps
    end
    
    add_index :events, :creator_id
    add_index :events, :supported_game_id
    add_index :events, :community_id
  end
end
