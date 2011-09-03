class AddAdminProfileIdToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :admin_profile_id, :integer
  end
end
