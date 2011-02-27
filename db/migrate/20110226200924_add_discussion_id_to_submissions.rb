class AddDiscussionIdToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :discussion_id, :intager
  end

  def self.down
    remove_column :submissions, :discussion_id   
  end
end
