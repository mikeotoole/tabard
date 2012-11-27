class RenameCharacterProxyOnAnnouncement < ActiveRecord::Migration
  def change
    add_column :announcements, :character_id, :integer
  end
end
