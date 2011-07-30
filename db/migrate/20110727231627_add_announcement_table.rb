class AddAnnouncementTable < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :name
      t.text :body
      t.integer :user_profile_id
      t.integer :game_id
      t.integer :community_id
      t.string :type
      t.boolean :comments_enabled,    :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
