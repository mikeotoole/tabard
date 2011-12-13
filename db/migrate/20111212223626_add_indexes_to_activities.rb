class AddIndexesToActivities < ActiveRecord::Migration
  def change
    add_index(:activities, :user_profile_id)
    add_index(:activities, :community_id)
    add_index(:activities, [:target_type, :target_id])
  end
end
