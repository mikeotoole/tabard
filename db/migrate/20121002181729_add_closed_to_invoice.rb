class AddClosedToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :is_closed, :boolean, default: false
  end
end
