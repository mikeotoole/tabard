class AddIsAnnouncementToDisscussionSpaces < ActiveRecord::Migration
  def change
    add_column :discussion_spaces, :is_announcement, :boolean, :default => false
  end
end
