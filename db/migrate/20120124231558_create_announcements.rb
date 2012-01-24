class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :name
      t.text :body
      t.integer :character_proxy_id
      t.integer :user_profile_id
      t.integer :community_id
      t.integer :supported_game_id
      t.boolean :is_locked, :default => false
      t.datetime :deleted_at
      t.boolean :has_been_edited, :default => false

      t.timestamps
    end
    add_index :announcements, :character_proxy_id
    add_index :announcements, :user_profile_id
    add_index :announcements, :community_id
    add_index :announcements, :supported_game_id
  end
end
