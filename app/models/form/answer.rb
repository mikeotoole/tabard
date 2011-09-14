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
  attr_accessible :body, :question, :submission

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
end
