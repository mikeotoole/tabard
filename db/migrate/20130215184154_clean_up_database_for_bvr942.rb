class CleanUpDatabaseForBvr942 < ActiveRecord::Migration
  def up
    drop_table(:character_proxies)
    drop_table(:character_proxies_community_applications)
    drop_table(:wows)
    drop_table(:wow_characters)
    drop_table(:swtors)
    drop_table(:swtor_characters)
    drop_table(:minecrafts)
    drop_table(:minecraft_characters)

    remove_index(:announcements, :character_proxy_id) if index_exists?(:announcements, :character_proxy_id)
    remove_column(:announcements, :character_proxy_id) if column_exists?(:announcements, :character_proxy_id)
    remove_index(:comments, :character_proxy_id) if index_exists?(:comments, :character_proxy_id)
    remove_column(:comments, :character_proxy_id) if column_exists?(:comments, :character_proxy_id)
    remove_index(:discussion_spaces, :character_proxy_id) if index_exists?(:discussion_spaces, :character_proxy_id)
    remove_column(:discussion_spaces, :character_proxy_id) if column_exists?(:discussion_spaces, :character_proxy_id)
    remove_index(:invites, :character_proxy_id) if index_exists?(:invites, :character_proxy_id)
    remove_column(:invites, :character_proxy_id) if column_exists?(:invites, :character_proxy_id)
    remove_index(:roster_assignments, :character_proxy_id) if index_exists?(:roster_assignments, :character_proxy_id)
    remove_column(:roster_assignments, :character_proxy_id) if column_exists?(:roster_assignments, :character_proxy_id)
  end

  def down
    raise ActiveRecord::IrreversibleMigration "This can't be reveresed"
  end
end
