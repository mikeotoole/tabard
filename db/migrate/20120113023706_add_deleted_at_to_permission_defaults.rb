class AddDeletedAtToPermissionDefaults < ActiveRecord::Migration
  def change
    add_column(:permission_defaults, :deleted_at, :datetime)
  end
end
