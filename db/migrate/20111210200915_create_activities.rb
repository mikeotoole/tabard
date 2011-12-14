class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_profile_id
      t.integer :community_id
      t.string :target_type
      t.integer :target_id
      t.string :action
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
