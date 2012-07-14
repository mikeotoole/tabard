class CreateSiteConfigurations < ActiveRecord::Migration
  def change
    create_table :site_configurations do |t|
      t.boolean :is_maintenance, default: false

      t.timestamps
    end
  end
end