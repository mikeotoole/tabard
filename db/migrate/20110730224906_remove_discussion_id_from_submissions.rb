class RemoveDiscussionIdFromSubmissions < ActiveRecord::Migration
  def self.up
    remove_column :submissions, :discussion_id
  end

  def self.down
    add_column :submissions, :discussion_id, :integer
  end
end
