class AddAnnouncementSpaceIdToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :announcement_space_id, :integer
  end

  def self.down
    remove_column :games, :announcement_space_id
  end
end
