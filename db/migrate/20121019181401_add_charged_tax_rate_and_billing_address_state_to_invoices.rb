class AddChargedTaxRateAndBillingAddressStateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :charged_tax_rate, :float, default: 0.0
    add_column :invoices, :billing_address_state, :string
  end
end
