# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  submission_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime
#  question_body :string(255)
#

require 'spec_helper'

describe Answer do
  let(:answer) { create(:answer) }

  it "should create a new instance given valid attributes" do
    answer.should be_valid
  end
  
  it "should require question_body" do
    build(:answer, :question_body => nil).should_not be_valid
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
  
  it "should change body into a CSV string if body is an Array" do
    answer = build(:answer)
    answer.body = %w(First Second Third)
    answer.save!
    answer.body.should eq "First, Second, Third"
  end
  
  describe "question" do
    it "should return the answers question on built answer" do
      answer = build(:answer)
      answer.question.should be_a(Question)
      answer.question.should eq Question.find(answer.question_id)
    end
    
    it "should return nil on existing answer" do
      db_answer = Answer.find(answer.id)
      db_answer.question.should be_nil
    end
  end
  
  describe "destroy" do    
    it "should mark answer as deleted" do
      answer.destroy
      Answer.exists?(answer).should be_false
      Answer.with_deleted.exists?(answer).should be_true
    end
  end
end
