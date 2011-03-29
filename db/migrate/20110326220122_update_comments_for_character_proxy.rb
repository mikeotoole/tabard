class UpdateCommentsForCharacterProxy < ActiveRecord::Migration
  def self.up
    rename_column :comments, :character_id, :character_proxy_id
  end

  def self.down
    rename_column :comments, :character_proxy_id, :character_id
  end
end
