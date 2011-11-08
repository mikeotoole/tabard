ActiveAdmin.register Question do
  menu false
  controller.authorize_resource

  actions :index, :show, :destroy

  member_action :delete_predefined_answer, :method => :put do
    answer = PredefinedAnswer.find(params[:id])
    answer.destroy
    redirect_to previous_page
  end
  
  show do
    attributes_table :id, :body, :explanation, :required, :type, :style, :custom_form, :created_at, :updated_at
    if question.respond_to?(:predefined_answers)
      div do      
        panel("Predefined Answers") do
          table_for(question.predefined_answers) do
            column :body
            column :created_at
            column "Destroy" do |predefined_answer|
              if can? :destroy, predefined_answer
                link_to "Destroy", delete_predefined_answer_admin_question_path(predefined_answer), :method => :put, :confirm => 'Are you sure you want to delete this predefined answer?'
              end  
            end        
          end
        end
      end
    end
  end   
end
 