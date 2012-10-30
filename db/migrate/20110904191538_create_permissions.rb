class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :role_id
      t.string :action
      t.string :permission_level
      t.string :subject_class
      t.integer :id_of_subject

      t.timestamps
    end

    add_index :permissions, :role_id
  end
end
