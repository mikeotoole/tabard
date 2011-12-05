# == Schema Information
#
# Table name: questions
#
#  id             :integer         not null, primary key
#  body           :text
#  custom_form_id :integer
#  type           :string(255)
#  style          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#

require 'spec_helper'

describe TextQuestion do
  let(:question) { create(:short_answer_question) }

  it "should create a new instance given valid attributes" do
    question.should be_valid
  end
  
  it "should be valid with valid style" do
    create(:short_answer_question).should be_valid
    create(:long_answer_question).should be_valid  
  end
  
  it "select_options should return all valid question types" do
    options = TextQuestion.select_options
    options.count.should eq(2)
    options[0][0].should eq("Short Answer Question")
    options[0][1].should eq("TextQuestion|short_answer_question")
    options[1][0].should eq("Long Answer Question")
    options[1][1].should eq("TextQuestion|long_answer_question")
  end
end
