class AddDontSendEmailToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :dont_send_email, :boolean, default: false
  end
end
