class AddPubliclyViewableToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :publicly_viewable, :boolean, :default => true
  end
end
