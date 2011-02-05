class RenameCommentsDisabledOnDiscussions < ActiveRecord::Migration
  def self.up
    change_table :discussions do |t|
      t.rename(:comments_disabled, :comments_enabled)
      t.change_default(:comments_enabled, true)
    end
  end

  def self.down
    change_table :discussions do |t|
      t.rename(:comments_enabled, :comments_disabled)
      t.change_default(:comments_disabled, false)
    end
  end
end
