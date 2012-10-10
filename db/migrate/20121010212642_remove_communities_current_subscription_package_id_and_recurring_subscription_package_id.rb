class RemoveCommunitiesCurrentSubscriptionPackageIdAndRecurringSubscriptionPackageId < ActiveRecord::Migration
  def up
    remove_index :communities, :community_announcement_space_id

    remove_index :communities, :current_subscription_package_id
    remove_index :communities, :recurring_subscription_package_id
    remove_column :communities, :current_subscription_package_id
    remove_column :communities, :recurring_subscription_package_id

    add_index :communities, :community_announcement_space_id, name: :index_comm_on_comm_announcement_space_id
  end

  def down
    add_column :communities, :current_subscription_package_id, :integer
    add_column :communities, :recurring_subscription_package_id, :integer
    add_index :communities, :current_subscription_package_id
    add_index :communities, :recurring_subscription_package_id
  end
end
