class AddBillingAddressZipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_address_zip, :string
  end
end
