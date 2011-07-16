class AddAvatarToSwtorCharacter < ActiveRecord::Migration
  def self.up
    add_column :swtor_characters, :avatar, :string
  end

  def self.down
    remove_column :swtor_characters, :avatar
  end
end
