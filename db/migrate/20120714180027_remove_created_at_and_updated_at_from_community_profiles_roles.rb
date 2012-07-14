class RemoveCreatedAtAndUpdatedAtFromCommunityProfilesRoles < ActiveRecord::Migration
  def up
    remove_index :community_profiles_roles, :community_profile_id
    remove_index :community_profiles_roles, :role_id
    remove_column :community_profiles_roles, :created_at
    remove_column :community_profiles_roles, :updated_at
    add_index :community_profiles_roles, :community_profile_id
    add_index :community_profiles_roles, :role_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
