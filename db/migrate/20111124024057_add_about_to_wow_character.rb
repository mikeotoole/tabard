class AddAboutToWowCharacter < ActiveRecord::Migration
  def change
    add_column(:wow_characters, :about, :text)
  end
end
