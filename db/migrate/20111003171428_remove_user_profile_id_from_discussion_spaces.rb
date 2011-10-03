class RemoveUserProfileIdFromDiscussionSpaces < ActiveRecord::Migration
  def change
    remove_index(:discussion_spaces, :column => :user_profile_id )
    remove_column(:discussion_spaces, :user_profile_id)
  end
end
