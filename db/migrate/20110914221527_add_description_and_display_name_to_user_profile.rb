class AddDescriptionAndDisplayNameToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :description, :text
    add_column :user_profiles, :display_name, :string
  end
end
