class RenameInvoicesStripeInvoiceIdToStripeChargeId < ActiveRecord::Migration
  def up
    rename_column :invoices, :stripe_invoice_id, :stripe_charge_id
  end

  def down
    rename_column :invoices, :stripe_charge_id, :stripe_invoice_id
  end
end
