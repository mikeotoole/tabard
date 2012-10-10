class RemoveInvoicesStripeCustomerId < ActiveRecord::Migration
  def up
    remove_column :invoices, :stripe_customer_id
  end

  def down
    add_column :invoices, :stripe_customer_id, :string
  end
end
