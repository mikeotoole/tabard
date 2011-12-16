class AddIsRemovedToCharacterProxies < ActiveRecord::Migration
  def change
    add_column(:character_proxies, :is_removed, :boolean, :default => false)
  end
end
