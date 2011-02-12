class AddNewFieldsToRegistrationApplicationForDiscussion < ActiveRecord::Migration
  def self.up
    add_column :registration_applications, :discussion_id, :integer
  end

  def self.down
    remove_column :registration_applications, :discussion_id
  end
end
