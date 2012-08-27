class CreateCommunityPlans < ActiveRecord::Migration
  def change
    create_table :community_plans do |t|
      t.string :title
      t.text :description
      t.integer :price_per_month_in_cents
      t.boolean :is_available, default: true

      t.timestamps
    end
    add_column :communities, :community_plan_id, :integer
  end
end
