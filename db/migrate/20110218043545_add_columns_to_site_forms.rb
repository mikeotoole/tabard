class AddColumnsToSiteForms < ActiveRecord::Migration
  def self.up
    add_column :site_forms, :registration_application_form, :boolean
    add_column :site_forms, :published, :boolean
  end

  def self.down
    remove_column :site_form, :registration_application_form
    remove_column :site_form, :published
  end
end
