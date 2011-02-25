class AddStatusToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :status, :integer
  end

  def self.down
    remove_column :profiles, :status
  end
end
