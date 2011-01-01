class AddTypeToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :type, :string
  end

  def self.down
    remove_column :announcements, :type
  end
end
