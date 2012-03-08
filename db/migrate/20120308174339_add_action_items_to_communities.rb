class AddActionItemsToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :action_items, :text
  end
end
