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

require 'spec_helper'
# 
# describe MultiSelectQuestion do
#   let(:question) { create(:check_box_question) }
# 
#   it "should create a new instance given valid attributes" do
#     question.should be_valid
#   end
#   
#   it "should be valid with valid style" do
#     create(:check_box_question).should be_valid
#   end
#   
#   it "select_options should return all valid question types" do
#     options = MultiSelectQuestion.select_options
#     options.count.should eq(1)
#     options[0][0].should eq("Check Box Question")
#     options[0][1].should eq("MultiSelectQuestion|check_box_question")
#   end
# end
