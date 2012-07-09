class CreateSupportTickets < ActiveRecord::Migration
  def change
    create_table :support_tickets do |t|
      t.integer :user_profile_id
      t.integer :admin_user_id
      t.string :status
      t.text :body

      t.timestamps
    end
    add_column :admin_users, :display_name, :string
    add_column :admin_users, :avatar, :string
  end
end
