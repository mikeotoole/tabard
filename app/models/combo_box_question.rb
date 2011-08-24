=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a combo box question.
=end
class ComboBoxQuestion < Question

=begin
  This method gets a path helper for a combo box question
  [Returns] The path helper for this combo box question.
=end
  def path_helper
     'combo_box_questions'
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

