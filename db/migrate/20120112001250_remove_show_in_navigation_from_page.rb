class RemoveShowInNavigationFromPage < ActiveRecord::Migration
  def up
  	remove_column :pages, :show_in_navigation
  end

  def down
  	add_column :pages, :show_in_navigation, :boolean, :default => false
  end
end
