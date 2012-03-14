class CreateMinecraftCharacters < ActiveRecord::Migration
  def change
    create_table :minecraft_characters do |t|
      t.string :name
      t.string :avatar
      t.text :about

      t.timestamps
    end
  end
end
