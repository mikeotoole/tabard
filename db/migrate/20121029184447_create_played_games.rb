class CreatePlayedGames < ActiveRecord::Migration
  def change
    create_table :played_games do |t|
      t.integer :game_id
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
