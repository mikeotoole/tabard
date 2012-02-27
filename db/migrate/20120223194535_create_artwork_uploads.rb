class CreateArtworkUploads < ActiveRecord::Migration
  def self.up
    create_table :artwork_uploads do |t|
      t.string :owner_name
      t.string :email
      t.string :street
      t.string :city
      t.string :zipcode
      t.string :state
      t.string :country
      t.string :attribution_name
      t.string :attribution_url
      t.string :artwork_image
      t.string :artwork_description
      t.boolean :certify_owner_of_artwork
      
      t.integer :document_id

      t.timestamps
    end
    
    add_index :artwork_uploads, :document_id
  end
  
  def self.down
    drop_table :artwork_uploads
  end
end
