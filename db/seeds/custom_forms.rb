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

  checkboxQ = MultiSelectQuestion.create!(:style => "check_box_question", :body => "A check box makes me feel.", :explanation => "This is a checkbox question", :is_required => true)
  checkboxQ.custom_form = test_form
  checkboxQ.save!
  PredefinedAnswer.create!(:body => "Happy", :select_question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => "Sad", :select_question_id => checkboxQ.id)
  PredefinedAnswer.create!(:body => "Copasetic", :select_question_id => checkboxQ.id)

  selectboxQ = SingleSelectQuestion.create!(:style => "select_box_question", :body => "Select boxes are?", :explanation => "This is a select box question")
  selectboxQ.custom_form = test_form
  selectboxQ.save!
  PredefinedAnswer.create!(:body => "Awesome", :select_question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Fun", :select_question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Silly", :select_question_id => selectboxQ.id)
  PredefinedAnswer.create!(:body => "Don't Care", :select_question_id => selectboxQ.id)

  radioQ = SingleSelectQuestion.create!(:style => "radio_buttons_question", :body => "Radio buttons are awesome.", :explanation => "This is a radio buttons question")
  radioQ.custom_form = test_form
  radioQ.save!
  PredefinedAnswer.create!(:body => "True", :select_question_id => radioQ.id)
  PredefinedAnswer.create!(:body => "False", :select_question_id => radioQ.id)
  PredefinedAnswer.create!(:body => "Don't Care", :select_question_id => radioQ.id)

  longQ = TextQuestion.create!(:style => "long_answer_question", :body => "Describe in 100 words or less how text boxes make you feel.", :explanation => "This is a long answer question")
  longQ.custom_form = test_form
  longQ.save!

  shortQ = TextQuestion.create!(:style => "short_answer_question", :body => "This is a ____ text question.", :explanation => "This is a short answer question")
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
