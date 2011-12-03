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
#  required       :boolean         default(FALSE)
#

require 'spec_helper'

describe SingleSelectQuestion do
  let(:question) { create(:select_box_question) }

  it "should create a new instance given valid attributes" do
    question.should be_valid
  end
  
  it "should be valid with valid style" do
    create(:select_box_question).should be_valid
    create(:radio_buttons_question).should be_valid
  end
  
  it "select_options should return all valid question types" do
    options = SingleSelectQuestion.select_options
    options.count.should eq(2)
    options[0][0].should eq("Select Box Question")
    options[0][1].should eq("SingleSelectQuestion|select_box_question")
    options[1][0].should eq("Radio Buttons Question")
    options[1][1].should eq("SingleSelectQuestion|radio_buttons_question")
  end
end
