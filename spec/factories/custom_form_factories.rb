FactoryGirl.define do
  factory :custom_form do
    sequence(:name) {|n| "Custom Form #{n}"}
    message "Fill out my form"
    thank_you "Thank You for submitting my form"
    published true
    community { DefaultObjects.community }
  end
  
  factory :custom_form_w_questions, :parent => :custom_form do
    after_create { |form| create_questions(form) }
  end
  
  factory :full_custom_form, :parent => :custom_form_w_questions do
    after_create { |form| create_submissions(form) }
  end

  factory :long_answer_queestion, :class => TextQuestion do
    style "long_answer_queestion"
    sequence(:body) {|n| "long_answer_queestion #{n}"}
    custom_form { DefaultObjects.custom_form }
  end
  
  factory :short_answer_queestion, :class => TextQuestion do
    style "short_answer_queestion"
    sequence(:body) {|n| "short_answer_queestion #{n}"}
    custom_form { DefaultObjects.custom_form }
  end
  
  factory :select_box_question, :class => SingleSelectQuestion do
    style "select_box_question"
    sequence(:body) {|n| "select_box_question #{n}"}
    custom_form { DefaultObjects.custom_form } 
    after_create { |question| create_predefined_answers(question) }
  end    
  
  factory :radio_buttons_question, :class => SingleSelectQuestion do
    style "radio_buttons_question"
    sequence(:body) {|n| "radio_buttons_question #{n}"}
    custom_form { DefaultObjects.custom_form }
    after_create { |question| create_predefined_answers(question) }
  end 
  
  factory :check_box_question, :class => MultiSelectQuestion do
    style "check_box_question"
    sequence(:body) {|n| "check_box_question #{n}"}
    custom_form { DefaultObjects.custom_form }
    after_create { |question| create_predefined_answers(question) }
  end
  
  factory :predefined_answer do
    sequence(:body) {|n| "predefined_answer #{n}"}
    question { FactoryGirl.create(:check_box_question) }
  end
  
  factory :answer do
    sequence(:body) {|n| "User given answer #{n}"}
    submission
    question { FactoryGirl.create(:check_box_question) }
  end

  factory :submission do
    user_profile { DefaultObjects.user_profile }
    custom_form { DefaultObjects.custom_form }
  end

  factory :submission_w_answers, :parent => :submission do
    user_profile { DefaultObjects.user_profile }
    custom_form { |submission| FactoryGirl.create(:custom_form_w_questions, :submission => submission) }
    after_create { |submission| create_answers(submission) }
  end
end

def create_questions(form)
  FactoryGirl.create(:long_answer_queestion, :custom_form => form)
  FactoryGirl.create(:short_answer_queestion, :custom_form => form)
  FactoryGirl.create(:select_box_question, :custom_form => form)
  FactoryGirl.create(:radio_buttons_question, :custom_form => form)
  FactoryGirl.create(:check_box_question, :custom_form => form)
end

def create_predefined_answers(question)
  3.times do
    FactoryGirl.create(:predefined_answer, :question => question)
  end
end

def create_submissions(form)
  FactoryGirl.create(:submission, :custom_form => form)
end

def create_answers(submission)
  submission.questions.each do |question|
    if question.respond_to?(:predefined_answers)
      FactoryGirl.create(:answer, :body => question.predefined_answers[1].body, :question => question, :submission => submission)
    else
      FactoryGirl.create(:answer, :question => question, :submission => submission)
    end
  end
end