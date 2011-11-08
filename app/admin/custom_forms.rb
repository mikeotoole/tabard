ActiveAdmin.register CustomForm do
  menu :if => proc{ can?(:read, CustomForm) }
  controller.authorize_resource

  member_action :delete_question, :method => :put do
    question = Question.find(params[:id])
    question.destroy
    redirect_to :action => :show, :id => question.custom_form.id
  end
  
  filter :id
  filter :name
  filter :instructions
  filter :thankyou
  filter :created_at
  filter :published, :as => :select
  
  index do
    column :id
    column :community
    column :name
    column :created_at
    column "Number Questions" do |custom_form|
      "#{custom_form.questions.count}"
    end
    column :published
    column "View" do |custom_form|
      link_to "View", admin_custom_form_path(custom_form)
    end
    column "Destroy" do |custom_form|
      if can? :destroy, custom_form
        link_to "Destroy", [:admin, custom_form], :method => :delete, :confirm => 'Are you sure you want to delete this custom form?'
      end  
    end
  end
  
  show do
    attributes_table :id, :community, :name, :instructions, :thankyou, :created_at, :updated_at, :published
    div do      
      panel("Questions") do
        table_for(custom_form.questions) do
          column "Name" do |question|
            link_to question.body, admin_question_path(question)
          end
          column :type
          column :style
          column "Predefined Answers" do |question|
            if question.respond_to?(:predefined_answers)
              question.predefined_answers.each do |predefined_answer|
                div do
                  li predefined_answer.body
                end
              end  
            end  
          end
        column "Destroy" do |question|
          if can? :destroy, question
            link_to "Destroy", delete_question_admin_custom_form_path(question), :method => :put, :confirm => 'Are you sure you want to delete this question?'
          end  
        end          
        end
      end
    end
    active_admin_comments
  end    
end
