class AddCharClassToWowCharacter < ActiveRecord::Migration
  def change
    add_column(:wow_characters, :char_class, :string)
  end
end
