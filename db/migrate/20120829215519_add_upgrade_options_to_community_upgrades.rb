class AddUpgradeOptionsToCommunityUpgrades < ActiveRecord::Migration
  def change
    add_column :community_upgrades, :upgrade_options, :text
    add_column :current_community_upgrades, :current_plan_expiration_date, :date
    add_column :current_community_upgrades, :subcription_amount, :integer
  end
end
