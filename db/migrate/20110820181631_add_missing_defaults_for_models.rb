class AddMissingDefaultsForModels < ActiveRecord::Migration
  def self.up
    say "Using workaround for SQlite name length issue", true
    suppress_messages {remove_index(:acknowledgment_of_announcements, :announcement_id)}
    change_column_default :acknowledgment_of_announcements, :acknowledged, false
    suppress_messages {add_index(:acknowledgment_of_announcements, :announcement_id)}

    say "Using workaround for SQlite name length issue", true
    suppress_messages {remove_index(:comments, [:commentable_id,:commentable_type])}
    change_column_default :comments, :has_been_deleted, false
    change_column_default :comments, :has_been_edited, false
    change_column_default :comments, :has_been_locked, false
    suppress_messages {add_index(:comments, [:commentable_id,:commentable_type])}

    change_column_default :communities, :accepting, true
    change_column_default :communities, :email_notice_on_applicant, true

    change_column_default :discussions, :has_been_locked, false

    change_column_default :games, :is_active, true

    change_column_default :message_copies, :deleted, false

    change_column_default :pages, :featured_page, false

    say "Using workaround for SQlite name length issue", true
    suppress_messages {remove_index(:permissions, [:permissionable_id,:permissionable_type])}
    change_column_default :permissions, :show_p, true
    change_column_default :permissions, :create_p, false
    change_column_default :permissions, :update_p, false
    change_column_default :permissions, :delete_p, false
    suppress_messages {add_index(:permissions, [:permissionable_id,:permissionable_type])}

    change_column_default :site_forms, :published, false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't reverse default values"
  end
end
