class AddTypeToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :type, :string
  end

  def self.down
    remove_column :characters, :type
  end
end
