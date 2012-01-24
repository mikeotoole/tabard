###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question with a multi selectable predefined answer.
###
class MultiSelectQuestion < SelectQuestion
###
# Constants
###
  # The list of vaild game subclass types.
  VALID_STYLES =  %w(check_box_question)

###
# Validators
###
  #validates :style, :inclusion => {:in => VALID_STYLES, :message => "%{value} is not a currently supported multi select question style"}
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
#  deleted_at     :datetime
#

