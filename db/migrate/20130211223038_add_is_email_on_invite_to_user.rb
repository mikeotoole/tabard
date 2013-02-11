class AddIsEmailOnInviteToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_email_on_invite, :boolean, default: true
  end
end
