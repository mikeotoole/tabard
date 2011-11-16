class AddUserActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_active, :boolean, :default => true
  end
end
