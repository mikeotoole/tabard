class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.string :name
      t.text :body
      t.integer :discussion_space_id
      t.integer :character_id
      t.integer :user_profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
