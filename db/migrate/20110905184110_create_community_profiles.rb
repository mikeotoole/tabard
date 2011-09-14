class CreateCommunityProfiles < ActiveRecord::Migration
  def change
    add_column :communities, :member_role_id, :integer
    add_index :communities, :member_role_id

    create_table :community_profiles do |t|
      t.integer :community_id
      t.integer :user_profile_id

      t.timestamps
    end
    add_index :community_profiles, :community_id
    add_index :community_profiles, :user_profile_id

    create_table :community_profiles_roles, :id => false do |t|
      t.references :community_profile
      t.references :role

      t.timestamps
    end
    add_index :community_profiles_roles, :community_profile_id
    add_index :community_profiles_roles, :role_id
  end
end
