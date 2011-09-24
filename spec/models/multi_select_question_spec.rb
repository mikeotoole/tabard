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

describe MultiSelectQuestion do
  let(:question) { create(:check_box_question) }

  it "should create a new instance given valid attributes" do
    question.should be_valid
  end
  
  it "shouldn't be valid with invalid style" do
    invalid_styles = %w{ not_a_style check_box_question_NOT select_box_question radio_buttons_question long_answer_question short_answer_question } # TESTING invalid question styles.
    invalid_styles.each do |style|
      build(:check_box_question, :style => style).should_not be_valid
    end
  end
  
  it "should be valid with valid style" do
    create(:check_box_question).should be_valid
  end
  
  it "select_options should return all valid question types" do
    options = MultiSelectQuestion.select_options
    options.count.should eq(1)
    options[0][0].should eq("Check Box Question")
    options[0][1].should eq("MultiSelectQuestion|check_box_question")
  end
end
