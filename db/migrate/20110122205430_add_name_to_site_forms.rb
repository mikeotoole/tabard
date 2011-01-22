class AddNameToSiteForms < ActiveRecord::Migration
  def self.up
    add_column :site_forms, :name, :string
  end

  def self.down
    remove_column :site_forms, :name
  end
end
