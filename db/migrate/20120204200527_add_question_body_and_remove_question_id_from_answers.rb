class AddQuestionBodyAndRemoveQuestionIdFromAnswers < ActiveRecord::Migration
  def up
    remove_index :answers, :question_id
    remove_column :answers, :question_id
    add_column :answers, :question_body, :string
  end
  
  def down
    add_column :answers, :question_id, :integer
    add_index :answers, :question_id
    remove_column :answers, :question_body
  end
end
