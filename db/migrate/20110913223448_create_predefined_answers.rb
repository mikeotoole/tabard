class CreatePredefinedAnswers < ActiveRecord::Migration
  def change
    create_table :predefined_answers do |t|
      t.text :body
      t.integer :select_question_id

      t.timestamps
    end
  end
end
