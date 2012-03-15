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
  validate :body_not_too_similar_to_others

  def body_not_too_similar_to_others
    return if self.body.blank?
    only_once = true
    question.predefined_answers.each do |pa|
      if pa.body_as_id == self.body_as_id
        if only_once
          only_once = false
        else
          self.errors.add(:body, "is too similar to another predefined answer.") 
          return false
        end
      end
    end
  end

  def body_as_id
    self.body.downcase.gsub(/[^0-9a-z]/, '')
  end
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
#  position    :integer         default(0)
#

