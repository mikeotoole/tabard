# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  question_id   :integer
#  submission_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

require 'spec_helper'

describe Answer do
  let(:answer) { Factory.create(:answer) }

  it "should create a new instance given valid attributes" do
    answer.should be_valid
  end
  
  it "should require question" do
    build(:answer, :question => nil).should_not be_valid
  end

  it "should not submission" do
    build(:answer, :submission => nil).should be_valid
  end
  
  it "should require body if question is required" do
    build(:required_answer, :body => nil).should_not be_valid
  end
  
  it "should not require body if question is not required" do
    build(:answer, :body => nil).should be_valid
  end
  
  describe "destroy" do
    it "should destroy question if its only attached to this answer" do
      question = answer.question
      question.update_attribute(:custom_form_id, nil)
      question.custom_form_id.should be_nil
      question.answers.count.should eq 1
      answer.destroy
      Question.exists?(question).should be_false
    end
    
    it "should not destroy question if its attached to other answers" do
      question = answer.question
      create(:answer, :question_id => question.id)
      question.answers.count.should eq 2
      answer.destroy
      Question.exists?(question).should be_true
    end
    
    it "should not destroy question if its attached to custom form" do
      question = create(:short_answer_question)
      answer = create(:answer, :question_id => question.id)
      question.answers.count.should eq 1
      answer.destroy
      Question.exists?(question).should be_true
    end
  end
end
