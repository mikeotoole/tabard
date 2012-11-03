class RenameCharacterProxyOnRosterAssignment < ActiveRecord::Migration
  def change
    rename_column :roster_assignments, :character_proxy_id, :character_id
  end
end
