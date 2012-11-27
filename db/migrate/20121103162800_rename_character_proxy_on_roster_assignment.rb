class RenameCharacterProxyOnRosterAssignment < ActiveRecord::Migration
  def change
    add_column :roster_assignments, :character_id, :integer
  end
end
