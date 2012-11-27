class RenameCharacterProxyOnInvite < ActiveRecord::Migration
  def change
    add_column :invites, :character_id, :integer
  end
end
