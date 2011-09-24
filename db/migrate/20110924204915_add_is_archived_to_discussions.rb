class AddIsArchivedToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :is_archived, :boolean, :default => false 
  end
end
