class AddDeletedAtToResources < ActiveRecord::Migration
  def change
    add_column(:communities, :deleted_at, :datetime)
    add_column(:answers, :deleted_at, :datetime)
    add_column(:comments, :deleted_at, :datetime)
    add_column(:community_applications, :deleted_at, :datetime)
    add_column(:community_profiles, :deleted_at, :datetime)
    add_column(:custom_forms, :deleted_at, :datetime)
    add_column(:discussion_spaces, :deleted_at, :datetime)
    add_column(:discussions, :deleted_at, :datetime)
    add_column(:page_spaces, :deleted_at, :datetime)
    add_column(:pages, :deleted_at, :datetime)
    add_column(:permissions, :deleted_at, :datetime)
    add_column(:predefined_answers, :deleted_at, :datetime)
    add_column(:questions, :deleted_at, :datetime)
    add_column(:roles, :deleted_at, :datetime)
    add_column(:roster_assignments, :deleted_at, :datetime)
    add_column(:submissions, :deleted_at, :datetime)
    add_column(:supported_games, :deleted_at, :datetime)
    add_column(:view_logs, :deleted_at, :datetime)
  end
end
