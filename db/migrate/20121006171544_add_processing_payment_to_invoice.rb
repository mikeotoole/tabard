class AddProcessingPaymentToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :processing_payment, :boolean, default: false
  end
end
