class AddUpgradeOptionsToCommunityUpgrades < ActiveRecord::Migration
  def change
    add_column :community_upgrades, :upgrade_options, :text
  end
end
