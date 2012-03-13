class CreateMinecrafts < ActiveRecord::Migration
  def change
    create_table :minecrafts do |t|
      t.string :server_type

      t.timestamps
    end
  end
end
