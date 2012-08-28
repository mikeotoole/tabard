class CreateCurrentCommunityUpgrades < ActiveRecord::Migration
  def change
    create_table :current_community_upgrades do |t|
      t.integer :community_id
      t.integer :community_upgrade_id
      t.integer :number_in_use

      t.timestamps
    end
    add_index :current_community_upgrades, :community_id
    add_index :current_community_upgrades, :community_upgrade_id
  end
end
