class RemovePredefinedAnswerIdFromQuestion < ActiveRecord::Migration
  def change
    remove_column(:questions, :predefined_answer_id)
  end
end
