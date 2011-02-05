class AddCommentsEnabledToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :comments_disabled, :boolean, :default => 0
  end

  def self.down
    remove_column :discussions, :comments_disabled
  end
end
