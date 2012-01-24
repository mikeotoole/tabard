class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.integer :community_id
      t.string :background_image
      t.string :predefined_theme

      t.timestamps
    end
  end
end
