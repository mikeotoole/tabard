class DropTableRegistrationApplications < ActiveRecord::Migration
  def self.up
    drop_table :registration_applications
  end

  def self.down
    create_table :registration_applications do |t|

      t.timestamps
    end
  end
end
