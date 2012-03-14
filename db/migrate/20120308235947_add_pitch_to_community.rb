class AddPitchToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :pitch, :string
  end
end
