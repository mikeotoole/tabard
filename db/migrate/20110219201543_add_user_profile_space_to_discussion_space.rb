class AddUserProfileSpaceToDiscussionSpace < ActiveRecord::Migration
  def self.up
    add_column :discussion_spaces, :user_profile_space, :boolean
    add_column :profiles, :discussion_space_id, :integer
  end

  def self.down
    remove_column :discussion_spaces, :user_profile_space
    remove_column :profiles, :discussion_space_id
  end
end
