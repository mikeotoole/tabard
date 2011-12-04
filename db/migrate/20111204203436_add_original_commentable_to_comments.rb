class AddOriginalCommentableToComments < ActiveRecord::Migration
  def change
    add_column(:comments, :original_commentable_id, :integer)
    add_column(:comments, :original_commentable_type, :string)
  end
end
