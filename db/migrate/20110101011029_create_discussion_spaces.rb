class CreateDiscussionSpaces < ActiveRecord::Migration
  def self.up
    create_table :discussion_spaces do |t|
      t.string :name
      t.boolean :system

      t.timestamps
    end
  end

  def self.down
    drop_table :discussion_spaces
  end
end
