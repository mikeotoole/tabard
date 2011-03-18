class FixDiscussionForNewCharacters < ActiveRecord::Migration
  def self.up
    add_column :wow_characters, :discussion_id, :integer
    add_column :swtor_characters, :discussion_id, :integer
    rename_column :discussions, :character_id, :character_proxy_id
  end

  def self.down
    remove_column :wow_characters, :discussion_id
    remove_column :swtor_characters, :discussion_id
    rename_column :discussions, :character_proxy_id, :character_id
  end
end
