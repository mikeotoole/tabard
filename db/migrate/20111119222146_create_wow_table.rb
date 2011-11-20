class CreateWowTable < ActiveRecord::Migration
  def change
    create_table :wows do |t|
      t.string :faction
      t.string :server_name
      t.string :server_type
      
      t.timestamps
    end
  end
end
