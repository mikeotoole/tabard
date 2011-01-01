class CreateAcknowledgmentOfAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :acknowledgment_of_announcements do |t|
      t.integer :announcement_id
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :acknowledgment_of_announcements
  end
end
