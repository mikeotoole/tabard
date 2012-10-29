class CreateCommunityGames < ActiveRecord::Migration
  def change
    create_table :community_games do |t|
      t.integer :community_id
      t.integer :game_id
      t.integer :game_announcement_space_id
      t.text :info

      t.timestamps
    end
  end
end
