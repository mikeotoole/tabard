###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a predefined answer.
###
class PredefinedAnswer < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  MAX_BODY_LENGTH = 50

###
# Attribute accessible
###
   attr_accessible :body, :question_id, :position

###
# Associations
###
   belongs_to :question, :inverse_of => :predefined_answers

###
# Validators
###
   validates :body, :presence => true,
                    :length => { :maximum => MAX_BODY_LENGTH },
                    :if => Proc.new {|pa| pa.question and pa.question.valid? }
   validates :question, :presence => true
end





# == Schema Information
#
# Table name: predefined_answers
#
#  id          :integer         not null, primary key
#  body        :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#

