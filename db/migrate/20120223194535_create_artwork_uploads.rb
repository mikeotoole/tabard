class CreateArtworkUploads < ActiveRecord::Migration
  def change
    create_table :artwork_uploads do |t|
      t.string :email
      t.string :attribution_name
      t.string :attribution_url
      t.string :artwork_image
      
      t.integer :document_id

      t.timestamps
    end
    
    add_index :artwork_uploads, :document_id
  end
end
