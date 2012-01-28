class AddGenderToCharacters < ActiveRecord::Migration
  def change
    add_column :wow_characters, :gender, :string
    add_column :swtor_characters, :gender, :string
  end
end
