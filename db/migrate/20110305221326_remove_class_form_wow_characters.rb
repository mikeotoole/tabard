class RemoveClassFormWowCharacters < ActiveRecord::Migration
  def self.up
    remove_column :wow_characters, :class
  end

  def self.down
    add_column :wow_characters, :class, :integer
  end
end
