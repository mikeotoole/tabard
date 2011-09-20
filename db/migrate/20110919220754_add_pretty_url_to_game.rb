class AddPrettyUrlToGame < ActiveRecord::Migration
  def change
    add_column :games, :pretty_url, :string
  end
end
