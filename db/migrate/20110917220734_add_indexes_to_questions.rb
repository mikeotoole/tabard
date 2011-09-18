class AddIndexesToQuestions < ActiveRecord::Migration
  def change
    add_index :questions, :custom_form_id
  end
end
