class CreateCommunityUpgrades < ActiveRecord::Migration
  def change
    create_table :community_upgrades do |t|
      t.string :title
      t.text :description
      t.integer :price_per_month_in_cents
      t.integer :max_number_of_upgrades

      t.timestamps
    end
  end
end
