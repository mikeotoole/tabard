class AddTypeToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :type, :string
  end

  def self.down
    remove_column :profiles, :type
  end
end
