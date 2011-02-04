class DropForms < ActiveRecord::Migration
  def self.up
    drop_table :forms
  end

  def self.down
  end
end
