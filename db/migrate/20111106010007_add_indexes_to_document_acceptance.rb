class AddIndexesToDocumentAcceptance < ActiveRecord::Migration
  def change
    add_index(:document_acceptances, :user_id)
    add_index(:document_acceptances, :document_id)
  end
end
