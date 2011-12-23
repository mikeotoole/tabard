class AddTitleToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :title, :string
  end
end
