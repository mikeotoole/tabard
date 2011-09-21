class CreateDiscussionSpaces < ActiveRecord::Migration
  def change
    create_table :discussion_spaces do |t|
      t.string :name
      t.integer :user_profile_id
      t.integer :game_id
      t.integer :community_id

      t.timestamps
    end

    add_index :discussion_spaces, :user_profile_id
    add_index :discussion_spaces, :game_id
    add_index :discussion_spaces, :community_id
  end
end
