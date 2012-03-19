class AddExpirationDateToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :expiration, :date_time

  end
end
