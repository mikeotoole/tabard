class AddPublicRosterToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :public_roster, :boolean, :default => true
  end
end
