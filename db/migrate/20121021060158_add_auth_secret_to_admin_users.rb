class AddAuthSecretToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :auth_secret, :string
  end
end
