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
    question = render :partial => 'subdomains/custom_forms/question', :locals => { :f => f, :question => Question.new }
    page = %{ $(this).parent('.add').before("#{escape_javascript question}"); }
    link_to_function name, page, options
  end
end
