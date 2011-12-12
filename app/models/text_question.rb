###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question with a user entered text answer.
###
class TextQuestion < Question
###
# Constants
###
  # The list of vaild game subclass types.
  VALID_STYLES = %w(short_answer_question long_answer_question)

###
# Validators
###
  #validates :style, :inclusion => {:in => VALID_STYLES, :message => "%{value} is not a currently supported text question style"}
end





# == Schema Information
#
# Table name: questions
#
#  id             :integer         not null, primary key
#  body           :text
#  custom_form_id :integer
#  type           :string(255)
#  style          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#

