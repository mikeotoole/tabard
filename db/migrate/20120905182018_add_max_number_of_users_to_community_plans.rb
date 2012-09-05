class AddMaxNumberOfUsersToCommunityPlans < ActiveRecord::Migration
  def change
    add_column :community_plans, :max_number_of_users, :integer, default: 0
  end
end
