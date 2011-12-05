class CreateCustomForms < ActiveRecord::Migration
  def change
    create_table :custom_forms do |t|
      t.string :name
      t.text :message
      t.string :thankyou
      t.boolean :is_published, :default => false
      t.integer :community_id

      t.timestamps
    end
  end
end
