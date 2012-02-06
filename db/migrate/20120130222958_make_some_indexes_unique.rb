class MakeSomeIndexesUnique < ActiveRecord::Migration
  def up
    remove_index :character_proxies, :name => :index_proxies_on_character_type_and_character_id
    remove_index :communities, :community_application_form_id
    remove_index :communities, :member_role_id
    add_index :character_proxies, [:character_type, :character_id], :unique => true, :name => :index_proxies_on_character_type_and_character_id
    add_index :communities, :community_application_form_id, :unique => true
    add_index :communities, :member_role_id, :unique => true
  end

  def down
    remove_index :character_proxies, :name => :index_proxies_on_character_type_and_character_id
    remove_index :communities, :community_application_form_id
    remove_index :communities, :member_role_id
    add_index :character_proxies, [:character_type, :character_id], :name => :index_proxies_on_character_type_and_character_id
    add_index :communities, :community_application_form_id
    add_index :communities, :member_role_id
  end
end