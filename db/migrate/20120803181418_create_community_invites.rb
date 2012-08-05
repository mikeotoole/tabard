class CreateCommunityInvites < ActiveRecord::Migration
  def change
    create_table :community_invites do |t|
      t.integer :applicant_id
      t.integer :sponsor_id
      t.integer :community_id

      t.timestamps
    end
    add_index :community_invites, :applicant_id
    add_index :community_invites, :sponsor_id
    add_index :community_invites, :community_id
  end
end
