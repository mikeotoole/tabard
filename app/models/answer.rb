=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents an answer.
=end
class Answer < ActiveRecord::Base
  #attr_accessible :question, :content, :submission

  belongs_to :question
  belongs_to :submission

=begin
  This method is a helper that gets the question id of this answer.
  [Returns] The id of this answers question, if possible, otherwise false.
=end
  def qHelp
    return self.question.id if question
    nil
  end

=begin
  This method gets the type.
  [Returns] The type of answer.
=end
  def type_helper
    self.type
  end

=begin
  This method sets the type.
  [Args]
    * +type+ -> A string that has the type to use.
  [Returns] True if the operation succeeded, otherwise false.
=end
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

