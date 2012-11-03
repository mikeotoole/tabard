class UpdateHasAndBelongsToForApplication < ActiveRecord::Migration
  def up
      drop_table(:character_proxies_community_applications)
      create_table :characters_community_applications, :id => false do |t|
        t.references :character, :null => false
        t.references :community_application, :null => false
      end
  end

  def down
    drop_table(:character_community_applications)
    create_table :character_proxies_community_applications, :id => false do |t|
      t.references :character_proxies, :null => false
      t.references :community_application, :null => false
    end
  end
end
