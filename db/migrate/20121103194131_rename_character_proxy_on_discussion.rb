class RenameCharacterProxyOnDiscussion < ActiveRecord::Migration
  def change
    rename_column :discussions, :character_proxy_id, :character_id
  end
end
