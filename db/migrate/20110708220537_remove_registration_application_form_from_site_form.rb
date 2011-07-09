class RemoveRegistrationApplicationFormFromSiteForm < ActiveRecord::Migration
  def self.up
    remove_column :site_forms, :registration_application_form
    add_column :communities, :community_application_form_id, :integer
  end

  def self.down
    add_column :site_forms, :registration_application_form, :boolean
    remove_column :communities, :community_application_form_id
  end
end
