class AddGameIdAndTypeToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :type, :string
    add_column :discussions, :game_id, :integer
  end

  def self.down
    remove_column :discussions, :type
    remove_column :discussions, :game_id
  end
end
