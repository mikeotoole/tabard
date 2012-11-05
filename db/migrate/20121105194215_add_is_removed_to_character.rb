class AddIsRemovedToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :is_removed, :boolean, deafult: true
  end
end
