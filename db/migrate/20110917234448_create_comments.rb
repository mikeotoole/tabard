class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_profile_id
      t.integer :character_proxy_id
      t.integer :community_id
      t.integer :commentable_id
      t.string :commentable_type
      t.boolean :is_removed, default: false
      t.boolean :has_been_edited, default: false
      t.boolean :is_locked, default: false

      t.timestamps
    end

    add_index :comments, :user_profile_id
    add_index :comments, :character_proxy_id
    add_index :comments, :community_id
    add_index :comments, [:commentable_type, :commentable_id], name: 'index_comments_on_commentable_type_and_id'
  end
end
