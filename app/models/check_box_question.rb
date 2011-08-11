=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a check box question.
=end
class CheckBoxQuestion < Question
  
=begin
  This method gets a path helper for a check box question
  [Returns] The path helper for this check box question.
=end
  def path_helper
     'check_box_questions'
  end
  
end

# == Schema Information
#
# Table name: questions
#
#  id           :integer         not null, primary key
#  content      :text
#  created_at   :datetime
#  updated_at   :datetime
#  site_form_id :integer
#  type         :string(255)
#

