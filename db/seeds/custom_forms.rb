###
# Helpers
###

# Creates a custom form with an example question of each type
def create_custom_form(community_name, form_name, published)
  puts "Creating #{community_name} custom form #{form_name}"
  community = Community.find_by_name(community_name)
  test_form = community.custom_forms.create!( :name => form_name,
                                              :is_published => published,
                                              :instructions => "My instructions. Phasellus ornare lacus eu neque hendrerit iaculis in in neque. Phasellus dolor velit, ultrices tempor porttitor eget, lacinia id risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem.",
                                              :thankyou => "My thankyou. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non. Phasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sapien.")

  checkboxQ = Question.create!(:style => "check_box_question", :body => "A check box makes me feel.", :explanation => "This is a checkbox question", :is_required => true)
  checkboxQ.custom_form = test_form
  checkboxQ.save!
  PredefinedAnswer.create!(:body => "Happy", :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => "Sad", :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => "Copasetic", :question_id => checkboxQ.id)

  selectboxQ = Question.create!(:style => "select_box_question", :body => "Select boxes are?", :explanation => "This is a select box question")
  selectboxQ.custom_form = test_form
  selectboxQ.save!
  PredefinedAnswer.create!(:body => "Awesome", :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Fun", :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Silly", :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Don't Care", :question_id => selectboxQ.id)

  radioQ = Question.create!(:style => "radio_buttons_question", :body => "Radio buttons are awesome.", :explanation => "This is a radio buttons question")
  radioQ.custom_form = test_form
  radioQ.save!
  PredefinedAnswer.create!(:body => "True", :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => "False", :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => "Don't Care", :question_id => radioQ.id)

  longQ = Question.create!(:style => "long_answer_question", :body => "Describe in 100 words or less how text boxes make you feel.", :explanation => "This is a long answer question")
  longQ.custom_form = test_form
  longQ.save!

  shortQ = Question.create!(:style => "short_answer_question", :body => "This is a ____ text question.", :explanation => "This is a short answer question")
  shortQ.custom_form = test_form
  shortQ.save!
end

def create_max_custom_form(community_name, published)
  puts "Creating #{community_name} custom form with max length"
  community = Community.find_by_name(community_name)
  test_form = community.custom_forms.create!( :name => create_w_string(CustomForm::MAX_NAME_LENGTH),
                                              :is_published => published,
                                              :instructions => create_w_string(CustomForm::MAX_INSTRUCTIONS_LENGTH),
                                              :thankyou => create_w_string(CustomForm::MAX_THANKYOU_LENGTH))

  checkboxQ = Question.create!(:style => "check_box_question", 
                               :body => create_w_string(Question::MAX_BODY_LENGTH), 
                               :explanation => create_w_string(Question::MAX_EXPLANATION_LENGTH), 
                               :is_required => true)
  checkboxQ.custom_form = test_form
  checkboxQ.save!
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => checkboxQ.id)

  selectboxQ = Question.create!(:style => "select_box_question", 
                                :body => create_w_string(Question::MAX_BODY_LENGTH), 
                                :explanation => create_w_string(Question::MAX_EXPLANATION_LENGTH))
  selectboxQ.custom_form = test_form
  selectboxQ.save!
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => selectboxQ.id)

  radioQ = Question.create!(:style => "radio_buttons_question", 
                            :body => create_w_string(Question::MAX_BODY_LENGTH), 
                            :explanation => create_w_string(Question::MAX_EXPLANATION_LENGTH))
  radioQ.custom_form = test_form
  radioQ.save!
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)
  PredefinedAnswer.create!(:body => create_w_string(PredefinedAnswer::MAX_BODY_LENGTH), :question_id => radioQ.id)

  longQ = Question.create!(:style => "long_answer_question", 
                           :body => create_w_string(Question::MAX_BODY_LENGTH), 
                           :explanation => create_w_string(Question::MAX_EXPLANATION_LENGTH))
  longQ.custom_form = test_form
  longQ.save!

  shortQ = Question.create!(:style => "short_answer_question", 
                            :body => create_w_string(Question::MAX_BODY_LENGTH), 
                            :explanation => create_w_string(Question::MAX_EXPLANATION_LENGTH))
  shortQ.custom_form = test_form
  shortQ.save!
end

unless @dont_run

  ###
  # Create Custom Forms
  ###

  # Just Another Headshot
  create_custom_form('Just Another Headshot', 'Test Published', true)
  create_custom_form('Just Another Headshot', 'Test NOT Published', false)

end
