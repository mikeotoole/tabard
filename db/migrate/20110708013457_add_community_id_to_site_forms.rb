class AddCommunityIdToSiteForms < ActiveRecord::Migration
  def self.up
    add_column :site_forms, :community_id, :integer
  end

  def self.down
    remove_column :site_forms, :community_id
  end
end
