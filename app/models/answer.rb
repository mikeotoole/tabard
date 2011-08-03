=begin
  Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Don't Steal Me Bro!
  
  This class represents an answer.
=end
class Answer < ActiveRecord::Base
  attr_accessible :question, :content
  
  belongs_to :question, :submission 
  
  def qHelp
    self.question.id if question
  end
  
  def type_helper
    self.type
  end
  
  def type_helper=(type)
    self.type = type
  end
  
end

# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  question_id   :integer
#  content       :text
#  created_at    :datetime
#  updated_at    :datetime
#  type          :string(255)
#  submission_id :integer
#

