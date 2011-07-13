class AddAvatarToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :avatar, :string
  end

  def self.down
    remove_column :profiles, :avatar
  end
end
