###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an answer.
###
class Answer < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :body, :question_id, :submission_id

###
# Associations
###
  belongs_to :question
  belongs_to :submission

###
# Validators
###
  validates :question, :presence => true
  #validates :submission, :presence => true
  validates :body, :presence => true, :if => Proc.new { |answer| answer.question_required }

###
# Delegates
###
  delegate :user_profile_id, :to => :submission, :allow_nil => true
  delegate :required, :to => :question, :prefix => true, :allow_nil => true
  delegate :body, :style, :type, :predefined_answers, :to => :question, :prefix => true

###
# Callbacks
###
  before_save :try_to_replicate

  # This trys to transform the body from an array to a comma separated string.
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
#  question_id   :integer
#  submission_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

