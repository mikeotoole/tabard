class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :name
      t.text :body
      t.integer :discussion_space_id
      t.integer :character_proxy_id
      t.integer :user_profile_id
      t.boolean :is_locked, default: false

      t.timestamps
    end

    add_index :discussions, :discussion_space_id
    add_index :discussions, :character_proxy_id
    add_index :discussions, :user_profile_id
  end
end
