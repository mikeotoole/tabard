FactoryGirl.define do
  factory :custom_form do
    sequence(:name) {|n| "Custom Form #{n}"}
    instructions "Fill out my form"
    thankyou "Thank You for submitting my form"
    published true
    community_id { DefaultObjects.community.id }
  end
  
  factory :custom_form_w_questions, :parent => :custom_form do
    after_create { |form| create_questions(form) }
  end
  
  factory :full_custom_form, :parent => :custom_form_w_questions do
    after_create { |form| create_submissions(form) }
  end

  factory :long_answer_question, :class => TextQuestion do
    style "long_answer_question"
    sequence(:body) {|n| "long_answer_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
  end

  factory :required_long_answer_question, :parent => :long_answer_question do
    required true
  end
  
  factory :short_answer_question, :class => TextQuestion do
    style "short_answer_question"
    sequence(:body) {|n| "short_answer_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
  end
  
  factory :select_box_question, :class => SingleSelectQuestion do
    style "select_box_question"
    sequence(:body) {|n| "select_box_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id } 
    after_create { |question| create_predefined_answers(question) }
  end    
  
  factory :radio_buttons_question, :class => SingleSelectQuestion do
    style "radio_buttons_question"
    sequence(:body) {|n| "radio_buttons_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
    after_create { |question| create_predefined_answers(question) }
  end 
  
  factory :check_box_question, :class => MultiSelectQuestion do
    style "check_box_question"
    sequence(:body) {|n| "check_box_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
    after_create { |question| create_predefined_answers(question) }
  end
  
  factory :predefined_answer do
    sequence(:body) {|n| "predefined_answer #{n}"}
    select_question_id { FactoryGirl.create(:check_box_question).id }
  end
  
  factory :answer do
    sequence(:body) {|n| "User given answer #{n}"}
    submission
    question_id { FactoryGirl.create(:long_answer_question).id }
  end
  factory :required_answer, :parent => :answer do
    question_id { FactoryGirl.create(:required_long_answer_question).id }
  end

  factory :submission do
    user_profile_id { DefaultObjects.user_profile.id }
    custom_form_id { DefaultObjects.custom_form.id }
  end

  factory :submission_w_answers, :parent => :submission do
    user_profile_id { DefaultObjects.user_profile.id }
    custom_form_id { FactoryGirl.create(:custom_form_w_questions).id }
    after_create { |submission| create_answers(submission) }
  end
end

def create_questions(form)
  FactoryGirl.create(:long_answer_question, :custom_form => form)
  FactoryGirl.create(:short_answer_question, :custom_form => form)
  FactoryGirl.create(:select_box_question, :custom_form => form)
  FactoryGirl.create(:radio_buttons_question, :custom_form => form)
  FactoryGirl.create(:check_box_question, :custom_form => form)
end

def create_predefined_answers(question)
  3.times do
    FactoryGirl.create(:predefined_answer, :select_question_id => question.id)
  end
end

def create_submissions(form)
  FactoryGirl.create(:submission, :custom_form => form)
end

def create_answers(submission)
  submission.custom_form.questions.each do |question|
    if question.respond_to?(:predefined_answers) and not question.predefined_answers.empty?
      FactoryGirl.create(:answer, :body => question.predefined_answers.first.body, :question => question, :submission => submission)
    else
      FactoryGirl.create(:answer, :question => question, :submission => submission)
    end
  end
end