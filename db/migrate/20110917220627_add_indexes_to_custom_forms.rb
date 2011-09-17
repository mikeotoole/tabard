class AddIndexesToCustomForms < ActiveRecord::Migration
  def change
    add_index :custom_forms, :community_id
  end
end
