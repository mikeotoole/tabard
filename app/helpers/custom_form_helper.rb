###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for custom forms.
###
module CustomFormHelper

  ###
  # Herp
  # [Args]
  #   * +derp+ -> derp
  # [Returns] herp
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
end
