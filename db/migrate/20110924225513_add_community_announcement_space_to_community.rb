class AddCommunityAnnouncementSpaceToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :community_announcement_space_id, :integer
  end
end
