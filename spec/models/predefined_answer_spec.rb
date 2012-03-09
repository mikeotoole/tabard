# == Schema Information
#
# Table name: predefined_answers
#
#  id          :integer         not null, primary key
#  body        :text
#  question_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  deleted_at  :datetime
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
  
  describe "destroy" do
    it "should mark predefined_answer as deleted" do
      predefined_answer.destroy
      PredefinedAnswer.exists?(predefined_answer).should be_false
      PredefinedAnswer.with_deleted.exists?(predefined_answer).should be_true
    end
  end
end
