class AddCharacterDiscussionSpaceToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :character_discussion_space_id, :integer
    add_column :characters, :discussion_id, :integer
  end

  def self.down
    remove_column :games, :character_discussion_space_id
    remove_column :characters, :discussion_id
  end
end
