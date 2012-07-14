class CreateRosterAssignments < ActiveRecord::Migration
  def change
    create_table :roster_assignments do |t|
      t.integer :community_profile_id
      t.integer :character_proxy_id
      t.boolean :is_pending, default: true

      t.timestamps
    end
    add_column :communities, :is_protected_roster, :boolean, default: false
    add_index :roster_assignments, :community_profile_id
    add_index :roster_assignments, :character_proxy_id
  end
end
