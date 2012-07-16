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
    question = render partial: 'subdomains/custom_forms/question', locals: { f: f, question: Question.new, q: 'newIndexQ' }
    page = %{
      newIndexQ = new Date().getTime();
      question = "#{escape_javascript question}";
      positionNumber = 0;
      $(this)
        .closest('form')
        .find('.questions')
        .append(question.replace(/newIndexQ/g,newIndexQ))
        .find('>li:last .container')
        .removeClass('closed')
        .trigger('init')
        .draggable(qDragOpts)
        .draggable('disable')
        .hide()
        .slideDown(400);
      $(this)
        .closest('form')
        .find('.questions input.position').each(function(){
          $(this).val(++positionNumber);
        });
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
  def add_predefined_answer_link(name, f, question, options={})
    answer = render partial: 'subdomains/custom_forms/answer', locals: { f: f, answer: question.predefined_answers.new, q: 'indexQ', a: 'newIndexA' }
    page = %{
      newIndexA = new Date().getTime();
      answers = $(this).closest('div').find('.answers');
      indexQ = answers.closest('li').attr('question');
      answer = "#{escape_javascript answer}";
      answer = answer.replace(/indexQ/g, indexQ).replace(/(\\[questions_attributes\\]\\[)\\d(\\])/g, "$1"+indexQ+"$2");
      answer = answer.replace(/newindex/g, newIndexA).replace(/(\\[predefined_answers_attributes\\]\\[)\\d(\\])/g, "$1"+newIndexA+"$2");
      answers
        .append(answer)
        .find('>li:last input')
        .focus();
    }
    link_to_function name, page, options
  end
end
