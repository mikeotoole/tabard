class UpdateHasAndBelongsToForApplication < ActiveRecord::Migration
  def up
      create_table :characters_community_applications, :id => false do |t|
        t.references :character, :null => false
        t.references :community_application, :null => false
      end
  end

  def down
    drop_table(:character_community_applications)
  end
end
