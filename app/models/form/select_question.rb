###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question with selectable predefined answers.
###
class SelectQuestion < Question
###
# Constants
###
  # The list of vaild game subclass types.
  VALID_STYLES = nil

###
# Attribute accessible
###
  attr_accessible :predefined_answer

###
# Associations
###
  has_many :predefined_answers, :dependent => :destroy

  accepts_nested_attributes_for :predefined_answers, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true

  # This makes it so the original rails clone method can still be used.
  alias_method :original_clone, :clone

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method overrides the clone method so the predefined answers are set to the clone.
  # [Returns] A clone of the select question with the predefined answers.
  ###
  def clone
    question = self.original_clone
    question.predefined_answers = self.predefined_answers
    question
  end
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

