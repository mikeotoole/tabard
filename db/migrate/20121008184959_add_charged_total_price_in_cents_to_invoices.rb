class AddChargedTotalPriceInCentsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :charged_total_price_in_cents, :integer
  end
end
