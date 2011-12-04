###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question with a single selectable predefined answer.
###
class SingleSelectQuestion < SelectQuestion
###
# Constants
###
  # The list of vaild game subclass types.
  VALID_STYLES =  %w(select_box_question radio_buttons_question)

###
# Validators
###
  #validates :style, :inclusion => {:in => VALID_STYLES, :message => "%{value} is not a currently supported single select question style"}
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
#  required       :boolean         default(FALSE)
#

