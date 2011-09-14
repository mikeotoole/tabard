class AddIndexForCommunityAdminProfileAndRoleCommunity < ActiveRecord::Migration
  def up
    add_index :communities, :admin_profile_id
    add_index :roles, :community_id
  end

  def down
    remove_index :communities, :admin_profile_id
    remove_index:roles, :community_id
  end
end
