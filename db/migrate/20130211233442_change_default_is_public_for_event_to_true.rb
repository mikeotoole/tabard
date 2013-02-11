class ChangeDefaultIsPublicForEventToTrue < ActiveRecord::Migration
  def up
    change_column :events, :is_public, :boolean, default: true
  end

  def down
    change_column :events, :is_public, :boolean, default: false
  end
end
