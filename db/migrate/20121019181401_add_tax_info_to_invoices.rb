class AddTaxInfoToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :charged_state_tax_rate, :float, default: 0.0
    add_column :invoices, :charged_local_tax_rate, :float, default: 0.0
    add_column :invoices, :local_tax_code, :string
    add_column :invoices, :billing_address_state, :string
  end
end
