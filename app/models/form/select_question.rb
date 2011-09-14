class SelectQuestion < Question
###
# Attribute accessible
###
  attr_accessible :predefined_answer

###
# Associations
###
  has_many :predefined_answers, :dependent => :destroy

  accepts_nested_attributes_for :predefined_answers, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true  
end

# == Schema Information
#
# Table name: questions
#
#  id                   :integer         not null, primary key
#  body                 :text
#  custom_form_id       :integer
#  type                 :string(255)
#  style                :string(255)
#  predefined_answer_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

