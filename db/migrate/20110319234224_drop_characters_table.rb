class DropCharactersTable < ActiveRecord::Migration
  def self.up
    drop_table :characters
  end

  def self.down
  end
end
