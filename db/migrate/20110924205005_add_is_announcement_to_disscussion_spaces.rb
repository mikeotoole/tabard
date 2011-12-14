class AddIsAnnouncementToDisscussionSpaces < ActiveRecord::Migration
  def change
    add_column :discussion_spaces, :is_announcement_space, :boolean, :default => false
  end
end
