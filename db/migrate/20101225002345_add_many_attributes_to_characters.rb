class AddManyAttributesToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :faction, :string
    add_column :characters, :race, :string
    add_column :characters, :klass, :string
    add_column :characters, :server, :string
    add_column :characters, :extra, :string
    add_column :characters, :rank, :intager
  end

  def self.down
    remove_column :characters, :faction
    remove_column :characters, :race
    remove_column :characters, :klass
    remove_column :characters, :server
    remove_column :characters, :extra
    remove_column :characters, :rank
  end
end
