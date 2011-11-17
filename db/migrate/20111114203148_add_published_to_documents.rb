class AddPublishedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :published, :boolean, :default => false
  end
end
