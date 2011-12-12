# == Schema Information
#
# Table name: predefined_answers
#
#  id                 :integer         not null, primary key
#  body               :text
#  select_question_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe PredefinedAnswer do
  let(:predefined_answer) { create(:predefined_answer) }

  it "should create a new instance given valid attributes" do
    predefined_answer.should be_valid
  end

  it "should require body" do
    build(:predefined_answer, :body => nil).should_not be_valid
  end

  it "should require select_question" do
    build(:predefined_answer, :question => nil).should_not be_valid
  end
end
