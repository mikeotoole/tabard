class CreateCommunityApplications < ActiveRecord::Migration
  def change
    create_table :community_applications do |t|
      t.integer :community_id
      t.integer :user_profile_id
      t.integer :submission_id
      t.string :status

      t.timestamps
    end

    add_index :community_applications, :community_id
    add_index :community_applications, :user_profile_id
    add_index :community_applications, :submission_id

    create_table :character_proxies_community_applications, :id => false do |t|
      t.integer :character_proxy_id
      t.integer :community_application_id
    end

    add_index :character_proxies_community_applications, :character_proxy_id, :name => "habtm_cproxy_app_proxy_id"
    add_index :character_proxies_community_applications, :community_application_id, :name => "habtm_cproxy_app_app_id"

    add_column :communities, :community_application_form_id, :integer
    add_index :communities, :community_application_form_id
  end
end
