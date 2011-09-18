class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :body
      t.integer :custom_form_id
      t.string :type
      t.string :style
      t.integer :predefined_answer_id

      t.timestamps
    end
  end
end
