class RemoveStripeSubscriptionDateFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :stripe_subscription_date
  end

  def down
    add_column :users, :stripe_subscription_date, :date
  end
end
