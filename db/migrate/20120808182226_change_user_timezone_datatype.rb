class ChangeUserTimezoneDatatype < ActiveRecord::Migration
  def up
    change_column :users, :time_zone, :integer, default: -8
  end

  def down
    change_column :users, :time_zone, :string, default: false
  end
end