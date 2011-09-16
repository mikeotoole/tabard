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

require 'spec_helper'

describe SelectQuestion do
  let(:question) { create(:select_box_question) }
  
  it "should respond to predefined_answers" do
    question.should respond_to :predefined_answers
  end

  it "clone should set predefined answers from cloned question" do
    question_clone = question.clone
    question_clone.should be_valid
    question_clone.predefined_answers.should eq(question.predefined_answers)
  end
end
