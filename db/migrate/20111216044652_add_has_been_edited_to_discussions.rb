class AddHasBeenEditedToDiscussions < ActiveRecord::Migration
  def change
    add_column(:discussions, :has_been_edited, :boolean, :default => false)
  end
end
