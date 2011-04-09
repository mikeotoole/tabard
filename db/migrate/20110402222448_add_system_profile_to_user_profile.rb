class AddSystemProfileToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :is_system_profile, :boolean
  end

  def self.down
    remove_column :profiles, :is_system_profile
  end
end
