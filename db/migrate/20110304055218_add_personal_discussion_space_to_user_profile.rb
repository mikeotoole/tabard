class AddPersonalDiscussionSpaceToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :personal_discussion_space_id, :integer
    add_column :discussion_spaces, :personal_space, :boolean
  end

  def self.down
    remove_column :profiles, :personal_discussion_space_id
    remove_column :discussion_spaces, :personal_space
  end
end
