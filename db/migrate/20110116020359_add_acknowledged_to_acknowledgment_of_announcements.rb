class AddAcknowledgedToAcknowledgmentOfAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :acknowledgment_of_announcements, :acknowledged, :boolean
  end

  def self.down
    remove_column :acknowledgment_of_announcements, :acknowledged
  end
end
