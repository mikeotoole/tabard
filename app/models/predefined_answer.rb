class PredefinedAnswer < Answer
  belongs_to :question, :submission 
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

