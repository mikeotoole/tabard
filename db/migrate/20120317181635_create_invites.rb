class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :event_id
      t.integer :user_profile_id
      t.integer :character_proxy_id
      t.string :status
      t.boolean :is_viewed, :default => :false

      t.timestamps
    end
    add_index :invites, :event_id
    add_index :invites, :user_profile_id
    add_index :invites, :character_proxy_id
  end
end
