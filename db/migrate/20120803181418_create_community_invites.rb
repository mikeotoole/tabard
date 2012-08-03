class CreateCommunityInvites < ActiveRecord::Migration
  def change
    create_table :community_invites do |t|
      t.integer :applicant_id
      t.integer :sponsor_id
      t.integer :community_id

      t.timestamps
    end
  end
end
