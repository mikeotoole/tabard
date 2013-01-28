class AddWasChargingExemptToInvoiceItem < ActiveRecord::Migration
  def change
    add_column :invoice_items, :was_charging_exempt, :boolean, default: false
  end
end
