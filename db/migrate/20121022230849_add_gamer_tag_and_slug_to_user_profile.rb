class AddGamerTagAndSlugToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :gamer_tag, :string
    add_column :user_profiles, :slug, :string

    add_index :user_profiles, :slug, unique: true
  end
end