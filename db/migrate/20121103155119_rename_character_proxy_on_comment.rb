class RenameCharacterProxyOnComment < ActiveRecord::Migration
  def change
    add_column :comments, :character_id, :integer
  end
end
