class AddAnswerToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :answers, :string
  end

  def self.down
    remove_column :questions, :answers
  end
end
