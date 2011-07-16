class AddCommunityIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :community_id, :integer
  end

  def self.down
    remove_column :comments, :community_id
  end
end
