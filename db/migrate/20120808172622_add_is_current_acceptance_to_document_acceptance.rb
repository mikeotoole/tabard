class AddIsCurrentAcceptanceToDocumentAcceptance < ActiveRecord::Migration
  def change
    add_column :document_acceptances, :is_current, :boolean, default: true
  end
end
