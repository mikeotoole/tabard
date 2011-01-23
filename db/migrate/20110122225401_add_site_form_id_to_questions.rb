class AddSiteFormIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :site_form_id, :integer
  end

  def self.down
    remove_column :questions, :site_form_id
  end
end
