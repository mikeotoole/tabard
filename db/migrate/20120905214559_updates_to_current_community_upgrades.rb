class UpdatesToCurrentCommunityUpgrades < ActiveRecord::Migration
  def up
    remove_index :current_community_upgrades, :community_id
    remove_index :current_community_upgrades, :community_upgrade_id
    remove_index :communities, :community_announcement_space_id
    remove_column :current_community_upgrades, :community_id
    remove_column :current_community_upgrades, :subcription_amount
    remove_column :communities, :community_plan_id
    add_index :current_community_upgrades, :community_upgrade_id
    add_index :communities, :community_announcement_space_id
  end

  def down
    add_column :current_community_upgrades, :community_id, :integer
    add_index :current_community_upgrades, :community_id
    add_column :current_community_upgrades, :subcription_amount, :integer
    remove_index :current_community_upgrades, :community_plan_id
    remove_column :current_community_upgrades, :community_plan_id
  end
end
