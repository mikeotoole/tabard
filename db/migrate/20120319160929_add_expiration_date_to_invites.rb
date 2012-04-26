class AddExpirationDateToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :expiration, :datetime
  end
end
