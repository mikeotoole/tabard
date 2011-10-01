class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :user_profile_id

      t.timestamps
    end
    
    add_index :folders, :user_profile_id
  end
end
