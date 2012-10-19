class AddDisputedDateRefundedDateAndRefundedPriceInCentsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :disputed_date, :datetime
    add_column :invoices, :refunded_date, :datetime
    add_column :invoices, :refunded_price_in_cents, :integer
  end
end
