class CreateAcknowledgements < ActiveRecord::Migration
  def change
    create_table :acknowledgements do |t|
      t.integer :community_profile_id
      t.integer :announcement_id
      t.boolean :has_been_viewed, :default => false

      t.timestamps
    end
    add_index :acknowledgements, :community_profile_id
    add_index :acknowledgements, :announcement_id
  end
end
