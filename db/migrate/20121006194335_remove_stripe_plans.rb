class RemoveStripePlans < ActiveRecord::Migration
  def up
    drop_table :stripe_plans
  end

  def down
    create_table :stripe_plans do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
