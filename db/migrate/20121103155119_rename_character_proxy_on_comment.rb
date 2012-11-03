class RenameCharacterProxyOnComment < ActiveRecord::Migration
  def change
    rename_column :comments, :character_proxy_id, :character_id
  end
end
