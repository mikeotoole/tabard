class AddAttributesToSwtorCharacters < ActiveRecord::Migration
  def change
    add_column(:swtor_characters, :char_class, :string)
    add_column(:swtor_characters, :race, :string)
    add_column(:swtor_characters, :level, :string)
    add_column(:swtor_characters, :about, :string)
  end
end
