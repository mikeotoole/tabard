class AddBillingAddressStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_address_state, :string
  end
end
