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
  attr_accessible :body, :question_id, :submission

###
# Associations
###
  belongs_to :question
  belongs_to :submission

###
# Validators
###
  validates :question, :presence => true
  validates :submission, :presence => true
  validates :body, :presence => true
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

