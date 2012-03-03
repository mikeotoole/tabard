class AddCommunityApplicationIdToCommunityProfile < ActiveRecord::Migration
  def change
    add_column :community_profiles, :community_application_id, :integer

  end
end
