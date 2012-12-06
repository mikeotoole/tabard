class AddTaxErrorOccurredToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :tax_error_occurred, :boolean, default: false
  end
end
