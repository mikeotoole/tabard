class CreateSupportedGames < ActiveRecord::Migration
  def change
    create_table :supported_games do |t|
      t.integer :community_id
      t.integer :game_id

      t.timestamps
    end
  end
end
