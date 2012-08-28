class CreateCommunityPlanUpgrades < ActiveRecord::Migration
  def change
    create_table :community_plan_upgrades do |t|
      t.integer :community_plan_id
      t.integer :community_upgrade_id

      t.timestamps
    end
    add_index :community_plan_upgrades, :community_plan_id
    add_index :community_plan_upgrades, :community_upgrade_id
  end
end
