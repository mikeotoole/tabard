class AddIsEmailOnMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_email_on_message, :boolean, default: true
  end
end
