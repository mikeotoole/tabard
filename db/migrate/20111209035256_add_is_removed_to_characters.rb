class AddIsRemovedToCharacters < ActiveRecord::Migration
  def change
    add_column(:swtor_characters, :is_removed, :boolean, :default => false)
    add_column(:wow_characters, :is_removed, :boolean, :default => false)
  end
end
