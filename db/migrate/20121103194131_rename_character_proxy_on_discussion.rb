class RenameCharacterProxyOnDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :character_id, :integer
  end
end
