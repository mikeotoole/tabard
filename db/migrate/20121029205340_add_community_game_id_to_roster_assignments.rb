class AddCommunityGameIdToRosterAssignments < ActiveRecord::Migration
  def change
    add_column :roster_assignments, :community_game_id, :integer
  end
end
