class AddLockingToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :has_been_locked, :boolean
  end

  def self.down
    remove_column :discussions, :has_been_locked
  end
end
