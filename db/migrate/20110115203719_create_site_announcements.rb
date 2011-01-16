class CreateSiteAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :site_announcements do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :site_announcements
  end
end
