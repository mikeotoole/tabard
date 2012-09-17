class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :price_each
      t.integer :quantity
      t.datetime :add_date
      t.datetime :start_date
      t.datetime :end_date
      t.string :discription
      t.string :item_type
      t.integer :item_id
      t.integer :community_id
      t.boolean :is_recurring, default: true
      t.boolean :is_prorated, default: false
      t.integer :invoice_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
