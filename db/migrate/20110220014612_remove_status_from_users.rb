class RemoveStatusFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :is_applicant
    remove_column :users, :is_active
  end

  def self.down
    add_column :users, :is_applicant, :boolean
    add_column :users, :is_active, :boolean
  end
end
