class CreateRegistrationApplications < ActiveRecord::Migration
  def self.up
    create_table :registration_applications do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :registration_applications
  end
end
