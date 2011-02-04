class AddFieldsToComment < ActiveRecord::Migration
  def self.up
  	add_column :comments, :has_been_deleted, :boolean
  	add_column :comments, :has_been_edited, :boolean
  	add_column :comments, :has_been_locked, :boolean
  end

  def self.down
  	remove_column :comments, :has_been_deleted
  	remove_column :comments, :has_been_edited
  	remove_column :comments, :has_been_locked
  end
end
