class AddIndexToPermissionsDefault < ActiveRecord::Migration
  def change
  	add_index(:permission_defaults, :role_id)
  end
end
