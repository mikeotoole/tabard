class AddWasChargeExemptToInvoiceItem < ActiveRecord::Migration
  def change
    add_column :invoice_items, :was_charge_exempt, :boolean, default: false
  end
end
