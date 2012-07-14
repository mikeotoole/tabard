###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an answer.
###
class Answer < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessor
###
  attr_accessor :question_id

###
# Attribute accessible
###
  attr_accessible :body, :question_body, :submission_id, :question_id

###
# Associations
###
  belongs_to :submission

###
# Validators
###
  validates :question_body, presence: true
  validates :body, presence: true, if: Proc.new { |answer| answer.question_is_required }

###
# Delegates
###
  delegate :user_profile_id, to: :submission, allow_nil: true
  delegate :is_required, :style, :predefined_answers, :explanation, to: :question, prefix: true, allow_nil: true

###
# Callbacks
###
  before_save :try_to_replicate

###
# Public Methods
###

###
# Instance Methods
###
  def question
    @question ||= Question.find_by_id(self.question_id)
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###

  ###
  # _before_save_
  #
  # This trys to transform the body from an array to a comma separated string.
  ###
  def try_to_replicate
    if self.body.is_a?(Array)
      self.body = self.body.delete_if{|elem| elem.blank?}.join(', ')
    end
  end
end







# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  submission_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime
#  question_body :string(255)
#

