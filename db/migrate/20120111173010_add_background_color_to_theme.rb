class AddBackgroundColorToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :background_color, :string
  end
end
