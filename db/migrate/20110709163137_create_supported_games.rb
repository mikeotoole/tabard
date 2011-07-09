class CreateSupportedGames < ActiveRecord::Migration
  def self.up
    create_table :supported_games do |t|
      t.integer :community_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :supported_games
  end
end
