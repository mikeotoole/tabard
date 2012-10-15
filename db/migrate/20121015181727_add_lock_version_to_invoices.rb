class AddLockVersionToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :lock_version, :integer, default: 0, null: false
  end
end
