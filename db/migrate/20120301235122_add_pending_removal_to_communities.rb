class AddPendingRemovalToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :pending_removal, :boolean, default: false
  end
end
