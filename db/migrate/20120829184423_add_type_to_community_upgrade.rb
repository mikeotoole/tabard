class AddTypeToCommunityUpgrade < ActiveRecord::Migration
  def change
    add_column :community_upgrades, :type, :string
  end
end
