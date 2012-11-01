class RenameCharacterProxyOnAnnouncement < ActiveRecord::Migration
  def change
    rename_column :announcements, :character_proxy_id, :character_id
  end
end
