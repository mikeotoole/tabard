class DropSiteAnnouncements < ActiveRecord::Migration
  def self.up
    drop_table :site_announcements

  end

  def self.down
    create_table :site_announcements do |t|

      t.timestamps
    end
  end
end
