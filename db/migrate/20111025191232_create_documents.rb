class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :type
      t.text :body
      t.string :version

      t.timestamps
    end
  end
end
