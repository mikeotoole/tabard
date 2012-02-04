class AddSupportedGameIdToRosterAssignment < ActiveRecord::Migration
  def change
    add_column :roster_assignments, :supported_game_id, :integer
    add_index :roster_assignments, :supported_game_id
  end
end
