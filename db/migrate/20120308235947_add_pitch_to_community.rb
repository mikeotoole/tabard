class AddPitchToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :pitch, :text
  end
end
