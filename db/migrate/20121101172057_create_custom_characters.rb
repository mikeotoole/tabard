class CreateCustomCharacters < ActiveRecord::Migration
  def change
    create_table :custom_characters do |t|

      t.timestamps
    end
  end
end
