class AddTypeToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :type, :string
  end

  def self.down
    remove_column :answers, :type
  end
end
