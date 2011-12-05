class AddPublishedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :is_published, :boolean, :default => false
  end
end
