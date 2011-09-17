###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a predefined answer.
###
class PredefinedAnswer < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :body, :select_question_id

###
# Associations
###
  belongs_to :select_question

###
# Validators
###
  validates :body, :presence => true
  validates :select_question, :presence => true
end

# == Schema Information
#
# Table name: predefined_answers
#
#  id                 :integer         not null, primary key
#  body               :text
#  select_question_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

