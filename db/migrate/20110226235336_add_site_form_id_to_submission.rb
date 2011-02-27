class AddSiteFormIdToSubmission < ActiveRecord::Migration
  def self.up
    add_column :submissions, :site_form_id, :integer
  end

  def self.down
    remove_column :submissions, :site_form_id
  end
end
