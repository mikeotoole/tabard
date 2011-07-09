class AddSpecialRolesToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :admin_role_id, :integer
    add_column :communities, :applicant_role_id, :integer
    add_column :communities, :member_role_id, :integer
  end

  def self.down
    remove_column :communities, :member_role_id
    remove_column :communities, :applicant_role_id
    remove_column :communities, :admin_role_id
  end
end
