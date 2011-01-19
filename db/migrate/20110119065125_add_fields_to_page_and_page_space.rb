class AddFieldsToPageAndPageSpace < ActiveRecord::Migration
  def self.up
    add_column :page_spaces, :name, :string
    add_column :pages, :title, :string
    add_column :pages, :body, :text
    add_column :pages, :page_space_id, :integer
  end

  def self.down
    remove_column :page_spaces, :name
    remove_column :pages, :title
    remove_column :pages, :body
    remove_column :pages, :page_space_id
  end
end
