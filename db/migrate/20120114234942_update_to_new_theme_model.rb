class UpdateToNewThemeModel < ActiveRecord::Migration
  def up
    remove_column :themes, :background_image
    add_column :communities, :background_image, :string
    remove_column :themes, :background_color
    add_column :communities, :background_color, :string
    remove_column :themes, :community_id
    add_column :communities, :theme_id, :integer
    add_index :communities, :theme_id
    remove_column :themes, :predefined_theme

    add_column :themes, :name, :string
    add_column :themes, :css, :string
    add_column :themes, :author, :string
    add_column :themes, :author_url, :string
    add_column :themes, :thumbnail, :string
  end

  def down
    add_column :themes, :background_image, :string
    remove_column :communities, :background_image
    add_column :themes, :background_color, :string
    remove_column :communities, :background_color
    add_column :themes, :community_id, :integer
    remove_column :communities, :theme_id
    remove_index :communities, :theme_id
    add_column :themes, :predefined_theme, :string

    remove_column :themes, :name
    remove_column :themes, :css
    remove_column :themes, :author
    remove_column :themes, :author_url
    remove_column :themes, :thumbnail
  end
end
