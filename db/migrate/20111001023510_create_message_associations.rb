class CreateMessageAssociations < ActiveRecord::Migration
  def change
    create_table :message_associations do |t|
      t.integer :message_id
      t.integer :recipient_id
      t.integer :folder_id
      t.boolean :is_removed, :default => false

      t.timestamps
    end

    add_index :message_associations, :message_id
    add_index :message_associations, :recipient_id
    add_index :message_associations, :folder_id
  end
end
