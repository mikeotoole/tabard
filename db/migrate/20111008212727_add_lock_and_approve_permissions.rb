class AddLockAndApprovePermissions < ActiveRecord::Migration
  def up
    add_column :permissions, :can_lock, :boolean, :default => false
    add_column :permissions, :can_accept, :boolean, :default => false
    remove_column :permissions, :action
    add_column :permissions, :parent_association_for_subject, :string
    add_column :permissions, :id_of_parent, :integer
  end
  def down
    remove_column :permissions, :can_lock
    remove_column :permissions, :can_accept
    add_column :permissions, :action, :string
    remove_column :permissions, :parent_association_for_subject
    remove_column :permissions, :id_of_parent
  end
end
