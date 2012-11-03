class AddAliasesToGames < ActiveRecord::Migration
  def change
    add_column :games, :aliases, :string
  end
end
