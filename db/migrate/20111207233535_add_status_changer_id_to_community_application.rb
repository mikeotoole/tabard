class AddStatusChangerIdToCommunityApplication < ActiveRecord::Migration
  def change
    add_column(:community_applications, :status_changer_id, :integer)
    add_index(:community_applications, :status_changer_id)
  end
end
