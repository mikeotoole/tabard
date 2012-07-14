class CreateViewLogs < ActiveRecord::Migration
  def change
    create_table :view_logs do |t|
      t.integer :user_profile_id
      t.integer :view_loggable_id
      t.string :view_loggable_type

      t.timestamps
    end

    add_index :view_logs, :user_profile_id
    add_index :view_logs, [:view_loggable_type, :view_loggable_id], name: 'index_view_logs_on_view_loggable_type_and_id'
  end
end
