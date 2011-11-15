class ChangeDocumentsVersionTypeToInteger < ActiveRecord::Migration
  def change
    remove_column(:documents, :version)
    add_column(:documents, :version, :integer)
  end
end
