class CreateStripePlans < ActiveRecord::Migration
  def change
    create_table :stripe_plans do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
