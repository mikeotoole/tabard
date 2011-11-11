ActiveAdmin.register Question do
  menu false
  controller.authorize_resource

  actions :index, :show, :destroy

  action_item :only => :show do
    if can? :delete_question, question.custom_form
      link_to "Delete Question", delete_question_admin_custom_form_path(question), :method => :put, :confirm => 'Are you sure you want to delete this question?'
    end  
  end

  member_action :delete_predefined_answer, :method => :put do
    answer = PredefinedAnswer.find(params[:id])
    answer.destroy
    redirect_to previous_page
  end
  
  index do
    column "View" do |question|
      link_to "View", admin_question_path(question)
    end
    column :body
    column :custom_form do |question|
      link_to question.custom_form.name , [:admin, question.custom_form]
    end
    column :type
    column :style
    column :created_at 
    column "Destroy" do |question|
      if can? :destroy, question
        link_to "Destroy", admin_question_path(question), :method => :delete, :confirm => 'Are you sure you want to delete this question?'
      end  
    end
  end  
  
  show do
    attributes_table *default_attribute_table_rows
    if question.respond_to?(:predefined_answers)
      div do      
        panel("Predefined Answers") do
          table_for(question.predefined_answers) do
            column :body
            column :created_at
            column "Destroy" do |predefined_answer|
              if can? :delete_predefined_answer, question
                link_to "Destroy", delete_predefined_answer_admin_question_path(predefined_answer), :method => :put, :confirm => 'Are you sure you want to delete this predefined answer?'
              end  
            end        
          end
        end
      end
    end
  end   
end
 