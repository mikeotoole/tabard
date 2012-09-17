class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.string :stripe_invoice_id
      t.datetime :period_start_date
      t.datetime :period_end_date
      t.datetime :paid_date
      t.string :stripe_customer_id
      t.integer :discount_percent_off
      t.string :discount_discription
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
