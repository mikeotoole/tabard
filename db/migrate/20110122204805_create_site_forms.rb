class CreateSiteForms < ActiveRecord::Migration
  def self.up
    create_table :site_forms do |t|
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :site_forms
  end
end
