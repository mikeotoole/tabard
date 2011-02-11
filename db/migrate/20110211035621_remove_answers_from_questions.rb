class RemoveAnswersFromQuestions < ActiveRecord::Migration
  def self.up
    remove_column :questions, :answers
  end

  def self.down
    add_column :questions, :answers, :string    
  end
end
