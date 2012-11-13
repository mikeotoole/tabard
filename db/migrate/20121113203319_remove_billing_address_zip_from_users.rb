class RemoveBillingAddressZipFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :billing_address_zip
  end

  def down
    add_column :users, :billing_address_zip, :string
  end
end
