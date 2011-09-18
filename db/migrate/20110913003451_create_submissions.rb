class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :custom_form_id
      t.integer :user_profile_id

      t.timestamps
    end
  end
end
