class TextQuestion < Question
  
  def path_helper
     'text_questions'
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

