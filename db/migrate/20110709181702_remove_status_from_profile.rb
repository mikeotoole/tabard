class RemoveStatusFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :status
    add_column :submissions, :status, :integer
  end

  def self.down
    add_column :profiles, :status, :integer
    remove_column :submissions, :status
  end
end
