class AddThankyouToSiteForms < ActiveRecord::Migration
  def self.up
    add_column :site_forms, :thankyou, :string
  end

  def self.down
    remove_column :site_forms, :thankyou
  end
end
