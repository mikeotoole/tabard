class DropAnnouncements < ActiveRecord::Migration
  def self.up
      drop_table :announcements
  end

  def self.down
      create_table :announcements do |t|
        t.string :title
        t.text :body
        t.integer :game_id

        t.timestamps
      end
  end
end
