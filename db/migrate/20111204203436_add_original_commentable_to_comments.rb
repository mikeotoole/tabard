class AddOriginalCommentableToComments < ActiveRecord::Migration
  def change
    add_column(:comments, :original_commentable_id, :integer)
    add_column(:comments, :original_commentable_type, :string)
    add_index(:comments, [:original_commentable_id, :original_commentable_type], name: :index_comments_original_commentable)
  end
end
