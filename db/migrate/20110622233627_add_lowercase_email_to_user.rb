class AddLowercaseEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :lowercase_email, :string
  end

  def self.down
    remove_column :users, :lowercase_email
  end
end
