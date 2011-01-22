class AddIsApplicantToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_applicant, :boolean
  end

  def self.down
    remove_column :users, :is_applicant
  end
end
