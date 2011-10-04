class RemoveUserProfileIdFromPageSpaces < ActiveRecord::Migration
  def change
    remove_index(:page_spaces, :column => :user_profile_id )
    remove_column(:page_spaces, :user_profile_id)
  end
end
