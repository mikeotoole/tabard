class RenameCharacterProxyOnInvite < ActiveRecord::Migration
  def change
    rename_column :invites, :character_proxy_id, :character_id
  end
end
