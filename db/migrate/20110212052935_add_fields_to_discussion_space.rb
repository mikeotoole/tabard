class AddFieldsToDiscussionSpace < ActiveRecord::Migration
  def self.up
    add_column :discussion_spaces, :registration_application_space, :boolean
  end

  def self.down
    remove_column :registration_application_space, :user_profile_id
  end
end
