class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :community_id
      t.string :name
      t.boolean :is_system_generated, default: false

      t.timestamps
    end
  end
end
