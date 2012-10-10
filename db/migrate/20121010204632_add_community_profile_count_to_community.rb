class AddCommunityProfileCountToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :community_profiles_count, :integer, default: 0
  end
end
