ActiveAdmin.register CustomForm do
  menu :parent => "Custom Forms", :priority => 1, :if => proc{ can?(:read, CustomForm) }
  controller.load_resource :only => :destroy
  controller.authorize_resource

  actions :index, :show, :destroy

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
  filter :is_published, :as => :select

  index do
    column "View" do |custom_form|
      link_to "View", admin_custom_form_path(custom_form)
    end
    column :id
    column :community do |custom_form|
      link_to custom_form.community_name, [:admin, custom_form.community]
    end
    column :name
    column :created_at
    column "Number Questions" do |custom_form|
      "#{custom_form.questions.count}"
    end
    column :is_published
    column "Destroy" do |custom_form|
      if can? :destroy, custom_form
        link_to "Destroy", [:admin, custom_form], :method => :delete, :confirm => 'Are you sure you want to delete this custom form?'
      end
    end
  end

  show :title => proc{ "#{custom_form.community_name} - #{custom_form.name}" } do
    attributes_table *default_attribute_table_rows
    div do
      panel("Questions") do
        table_for(custom_form.questions) do
          column "View" do |question|
            link_to "View", admin_question_path(question)
          end
          column :body
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
