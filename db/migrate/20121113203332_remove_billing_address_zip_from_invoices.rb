class RemoveBillingAddressZipFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :billing_address_zip
  end

  def down
    add_column :invoices, :billing_address_zip, :string
  end
end
