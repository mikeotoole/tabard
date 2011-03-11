class AddFeaturedPageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :featured_page, :boolean
  end

  def self.down
    remove_column :pages, :featured_page
  end
end
