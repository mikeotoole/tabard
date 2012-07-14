class AddPublicRosterToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :is_public_roster, :boolean, default: true
  end
end
