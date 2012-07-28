FactoryGirl.define do
  factory :custom_form do
    sequence(:name) {|n| "Custom Form #{n}"}
    instructions "Fill out my form"
    thankyou "Thank You for submitting my form"
    is_published true
    community_id { DefaultObjects.community.id }
  end
  
  factory :custom_form_w_questions, :parent => :custom_form do
    after(:create) { |form| create_questions(form) }
  end
  
  factory :full_custom_form, :parent => :custom_form_w_questions do
    after(:create) { |form| create_submissions(form) }
  end

  factory :long_answer_question, :class => Question do
    style "long_answer_question"
    sequence(:body) {|n| "long_answer_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
  end

  factory :required_long_answer_question, :parent => :long_answer_question do
    is_required true
  end
  
  factory :short_answer_question, :class =>Question do
    style "short_answer_question"
    sequence(:body) {|n| "short_answer_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
  end
  
  factory :select_box_question, :class => Question do
    style "select_box_question"
    sequence(:body) {|n| "select_box_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id } 
    predefined_answers_attributes { [FactoryGirl.attributes_for(:predefined_answer, :question_id => nil)] }
  end
  
  factory :radio_buttons_question, :class => Question do
    style "radio_buttons_question"
    sequence(:body) {|n| "radio_buttons_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
    predefined_answers_attributes { [FactoryGirl.attributes_for(:predefined_answer, :question_id => nil)] }
  end 
  
  factory :check_box_question, :class => Question do
    style "check_box_question"
    sequence(:body) {|n| "check_box_question #{n}"}
    custom_form_id { DefaultObjects.custom_form.id }
    predefined_answers_attributes { [FactoryGirl.attributes_for(:predefined_answer, :question_id => nil)] }
  end
  
  factory :predefined_answer do
    sequence(:body) {|n| "predefined_answer #{n}"}
    question_id { FactoryGirl.create(:check_box_question).id }
  end
  
  factory :answer do
    body "User given answer"
    submission
    question_id { FactoryGirl.create(:long_answer_question).id }
    question_body { FactoryGirl.create(:long_answer_question).body }
  end

  factory :required_answer, :parent => :answer do
    question_id { FactoryGirl.create(:required_long_answer_question).id }
    question_body { FactoryGirl.create(:long_answer_question).body }
  end

  factory :submission do
    user_profile_id { DefaultObjects.user_profile.id }
    custom_form_id { DefaultObjects.custom_form.id }
  end

  factory :submission_w_answers, :parent => :submission do
    user_profile_id { DefaultObjects.user_profile.id }
    custom_form_id { FactoryGirl.create(:custom_form_w_questions).id }
    after(:create) { |submission| create_answers(submission) }
  end
end

def create_questions(form)
  FactoryGirl.create(:long_answer_question, :custom_form => form)
  FactoryGirl.create(:short_answer_question, :custom_form => form)
  FactoryGirl.create(:select_box_question, :custom_form => form)
  FactoryGirl.create(:radio_buttons_question, :custom_form => form)
  FactoryGirl.create(:check_box_question, :custom_form => form)
end

def create_submissions(form)
  FactoryGirl.create(:submission, :custom_form => form)
end

def create_answers(submission)
  submission.custom_form.questions.each do |question|
    unless question.predefined_answers.empty?
      FactoryGirl.create(:answer, :body => question.predefined_answers.first.body, :question_id => question.id, :question_body => question.body, :submission => submission)
    else
      FactoryGirl.create(:answer, :question_id => question.id, :question_body => question.body , :submission => submission)
    end
  end
end