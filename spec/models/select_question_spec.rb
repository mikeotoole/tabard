# == Schema Information
#
# Table name: questions
#
#  id             :integer         not null, primary key
#  body           :text
#  custom_form_id :integer
#  style          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#  deleted_at     :datetime
#

# require 'spec_helper'
# 
# describe SelectQuestion do
#   let(:question) { create(:select_box_question) }
#   
#   it "should respond to predefined_answers" do
#     question.should respond_to :predefined_answers
#   end
# end
