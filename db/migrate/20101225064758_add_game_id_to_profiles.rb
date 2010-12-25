class AddGameIdToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :game_id, :integer
  end

  def self.down
    remove_column :profiles, :game_id
  end
end
