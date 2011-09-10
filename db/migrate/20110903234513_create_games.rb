class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :type
      t.boolean :is_active, :default => true

      t.timestamps
    end
  end
end
