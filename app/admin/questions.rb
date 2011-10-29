ActiveAdmin.register Question do
  menu false
  controller.authorize_resource
  
  show do
    attributes_table :id, :body, :explanation, :required, :type, :style, :custom_form, :created_at, :updated_at
    if question.respond_to?(:predefined_answers)
      h3 "Predefined Answers:"
      question.predefined_answers.each do |predefined_answer|
        div do
          li predefined_answer.body
        end
      end
    end
    active_admin_comments
  end   
end
 