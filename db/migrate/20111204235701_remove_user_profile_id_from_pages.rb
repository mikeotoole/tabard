class RemoveUserProfileIdFromPages < ActiveRecord::Migration
  def up
    remove_column :pages, :character_proxy_id
    remove_column :pages, :user_profile_id
  end

  def down
    add_column :pages, :character_proxy_id, :integer
    add_column :pages, :user_profile_id, :integer
  end
end
