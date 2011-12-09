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
  validates :body,  :presence => true,
                    :length => { :maximum => 100 }
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
#  deleted_at         :datetime
#

