class CreateSubscriptionPackages < ActiveRecord::Migration
  def change
    create_table :subscription_packages do |t|
      t.integer :community_plan_id
      t.date :end_date

      t.timestamps
    end
    add_column :communities, :current_subscription_package_id, :integer
    add_index :communities, :current_subscription_package_id
    add_column :communities, :recurring_subscription_package_id, :integer
    add_index :communities, :recurring_subscription_package_id
    add_column :current_community_upgrades, :subscription_package_id, :integer
    add_index :current_community_upgrades, :subscription_package_id
  end
end
