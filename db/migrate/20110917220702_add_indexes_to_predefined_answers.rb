class AddIndexesToPredefinedAnswers < ActiveRecord::Migration
  def change
    add_index :predefined_answers, :select_question_id
  end
end
