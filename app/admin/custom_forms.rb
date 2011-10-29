ActiveAdmin.register CustomForm do
  controller.authorize_resource
  
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
    attributes_table :community, :name, :instructions, :thankyou, :created_at, :updated_at, :published
    h3 "Questions:"
    custom_form.questions.each do |question|
      div do
        link_to question.body, admin_question_path(question)
      end
      if question.respond_to?(:predefined_answers)
        question.predefined_answers.each do |predefined_answer|
          div do
            li predefined_answer.body
          end
        end
      end    
    end
    active_admin_comments
  end    
end
