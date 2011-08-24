=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a predefined answer.
=end
class PredefinedAnswer < Answer
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

