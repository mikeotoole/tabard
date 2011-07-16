class AddAvatarToWowCharacter < ActiveRecord::Migration
  def self.up
    add_column :wow_characters, :avatar, :string
  end

  def self.down
    remove_column :wow_characters, :avatar
  end
end
