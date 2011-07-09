class AddCommunityIdToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :community_id, :integer
  end

  def self.down
    remove_column :roles, :community_id
  end
end
