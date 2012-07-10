class CreateSupportComments < ActiveRecord::Migration
  def change
    create_table :support_comments do |t|
      t.integer :support_ticket_id
      t.integer :user_profile_id
      t.integer :admin_user_id
      t.text :body

      t.timestamps
    end
    add_index :support_tickets, :user_profile_id
    add_index :support_tickets, :admin_user_id
    add_index :support_comments, :support_ticket_id
    add_index :support_comments, :user_profile_id
    add_index :support_comments, :admin_user_id
  end
end
