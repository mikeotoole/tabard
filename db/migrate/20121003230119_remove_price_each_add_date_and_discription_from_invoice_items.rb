class RemovePriceEachAddDateAndDiscriptionFromInvoiceItems < ActiveRecord::Migration
  def up
    remove_column :invoice_items, :price_each
    remove_column :invoice_items, :add_date
    remove_column :invoice_items, :discription
  end

  def down
    add_column :invoice_items, :price_each, :integer
    add_column :invoice_items, :add_date, :datetime
    add_column :invoice_items, :discription, :string
  end
end
