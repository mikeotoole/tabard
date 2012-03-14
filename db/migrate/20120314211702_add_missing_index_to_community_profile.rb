class AddMissingIndexToCommunityProfile < ActiveRecord::Migration
  def change
  	add_index :community_profiles, :community_application_id
  end
end
