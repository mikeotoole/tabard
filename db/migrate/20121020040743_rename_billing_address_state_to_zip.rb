class RenameBillingAddressStateToZip < ActiveRecord::Migration
  def up
    rename_column :invoices, :billing_address_state, :billing_address_zip
  end

  def down
    rename_column :invoices, :billing_address_zip, :billing_address_state
  end
end
