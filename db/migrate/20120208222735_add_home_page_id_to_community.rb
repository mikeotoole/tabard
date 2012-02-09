class AddHomePageIdToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :home_page_id, :integer
    add_index :communities, :home_page_id
  end
end