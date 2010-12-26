class CreateSystemResources < ActiveRecord::Migration
  def self.up
    create_table :system_resources do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :system_resources
  end
end
