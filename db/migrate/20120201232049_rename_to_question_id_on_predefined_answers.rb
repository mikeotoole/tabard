class RenameToQuestionIdOnPredefinedAnswers < ActiveRecord::Migration
  def change
    rename_column(:predefined_answers, :select_question_id, :question_id)
  end
end
