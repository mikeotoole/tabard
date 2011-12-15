###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a predefined answer.
###
class PredefinedAnswer < ActiveRecord::Base
###
# Constants
###
  MAX_BODY_LENGTH = 30
  
###
# Attribute accessible
###
   attr_accessible :body, :select_question_id

###
# Associations
###
   belongs_to :question, :foreign_key => :select_question_id, :inverse_of => :predefined_answers

###
# Validators
###
   validates :body, :presence => true,
                    :length => { :maximum => MAX_BODY_LENGTH }
   validates :question, :presence => true
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

