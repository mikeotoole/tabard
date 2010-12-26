class CorrectAssociationForRolesAndUsers < ActiveRecord::Migration
  def self.up
    remove_column :roles, :user_id
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    add_column :roles, :user_id, :integer
    drop_table :roles_users
  end
end
