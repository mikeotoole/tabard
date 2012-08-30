class AddStripeSubscriptionDateToUsers < ActiveRecord::Migration
  def up
    remove_index :current_community_upgrades, :community_upgrade_id
    add_column :users, :stripe_subscription_date, :date
    remove_column :current_community_upgrades, :current_plan_expiration_date
    add_index :current_community_upgrades, :community_upgrade_id
  end
  def down
    remove_index :current_community_upgrades, :community_upgrade_id
    remove_column :users, :stripe_subscription_date
    add_column :current_community_upgrades, :current_plan_expiration_date, :date
    add_index :current_community_upgrades, :community_upgrade_id
  end
end
