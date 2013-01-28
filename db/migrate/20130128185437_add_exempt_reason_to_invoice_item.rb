class AddExemptReasonToInvoiceItem < ActiveRecord::Migration
  def change
    add_column :invoice_items, :charge_exempt_label, :string
    add_column :invoice_items, :charge_exempt_reason, :text
  end
end
