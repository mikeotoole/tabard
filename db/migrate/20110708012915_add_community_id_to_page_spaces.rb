class AddCommunityIdToPageSpaces < ActiveRecord::Migration
  def self.up
    add_column :page_spaces, :community_id, :integer
  end

  def self.down
    remove_column :page_spaces, :community_id
  end
end
