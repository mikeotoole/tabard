class AddCommunityToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :discussions, :community_id, :integer
  end

  def self.down
    remove_column :discussions, :community_id
  end
end
