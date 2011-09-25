class AddCommunityAnnouncementSpaceToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :community_announcement_space_id, :integer
    add_index :communities, :community_announcement_space_id
  end
end
