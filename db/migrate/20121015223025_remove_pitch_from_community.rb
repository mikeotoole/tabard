class RemovePitchFromCommunity < ActiveRecord::Migration
  def up
    remove_index :communities, :community_announcement_space_id
    remove_column :communities, :pitch
    add_index :communities, :community_announcement_space_id, name: "short_com_announcement_id"
  end

  def down
    remove_index :communities, :community_announcement_space_id
    add_column :communities, :pitch, :string
    add_index :communities, :community_announcement_space_id, name: "short_com_announcement_id"
  end
end
