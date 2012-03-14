class AddSearchingIndexes < ActiveRecord::Migration
  def change
    add_index :user_profiles, :display_name
    add_index :user_profiles, :location
    add_index :communities, :name
  end
end
