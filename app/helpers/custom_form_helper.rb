###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for custom forms.
###
module CustomFormHelper

  ###
  # Builds a dynamic javascript link for adding a new question based on the question partial
  # [Args]
  #   * +name+ -> The anchor text displayed for the link to be generated
  #   * +f+ -> The form object the question will be associated with
  #   * +options+ -> Block passed directly to the link
  # [Returns] A link that uses JavaScript to add new question html to the desired form
  ###
  def add_question_link(name, f, options={})
    question = render :partial => 'subdomains/custom_forms/question', :locals => { :f => f, :question => Question.new, :q => 'noindex' }
    page = %{
      newIndex = new Date().getTime();
      question = "#{escape_javascript question}";
      $(this)
        .closest('form')
        .find('.questions')
        .append(question.replace(/noindex/g,newIndex))
        .find('>li:last')
        .trigger('init')
        .hide()
        .slideDown(400);
    }
    link_to_function name, page, options
  end
  
  ###
  # Builds a dynamic javascript link for adding a new predefined answer based on the form and question
  # [Args]
  #   * +name+ -> The anchor text displayed for the link to be generated
  #   * +f+ -> The form object the question will be associated with
  #   * +q+ -> The question field index the predefined answer will be associated with
  #   * +options+ -> Block passed directly to the link
  # [Returns] A link that uses JavaScript to add new predefined answer html to the desired form question
  ###
  def add_predefined_answer_link(name, f, question, q, options={})
    answer = render :partial => 'subdomains/custom_forms/answer', :locals => { :f => f, :answer => question.predefined_answers.new, :q => q, :a => 'noindex' }
    page = %{
      newIndex = new Date().getTime();
      answers = $(this).closest('div').find('.answers');
      answer = "#{escape_javascript answer}";
      answers
        .append(answer.replace(/noindex/g,newIndex).replace(/(\\[predefined_answers_attributes\\]\\[)\\d(\\])/g,"$1"+newIndex+"$2"))
        .find('>li:last input')
        .focus();
    }
    link_to_function name, page, options
  end
end
