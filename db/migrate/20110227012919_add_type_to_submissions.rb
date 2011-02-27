class AddTypeToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :type, :string
  end

  def self.down
    remove_column :submissions, :type
  end
end
