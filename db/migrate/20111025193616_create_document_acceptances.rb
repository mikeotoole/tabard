class CreateDocumentAcceptances < ActiveRecord::Migration
  def change
    create_table :document_acceptances do |t|
      t.integer :user_id
      t.integer :document_id

      t.timestamps
    end
    add_column(:users, :accepted_current_terms_of_service, :boolean, {default: false})
    add_column(:users, :accepted_current_privacy_policy, :boolean, {default: false})
  end
end
