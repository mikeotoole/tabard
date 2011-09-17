class AddIndexesToAnswers < ActiveRecord::Migration
  def change
  	add_index :answers, :question_id
  	add_index :answers, :submission_id
  end
end
