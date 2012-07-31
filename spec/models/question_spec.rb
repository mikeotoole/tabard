# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  custom_form_id :integer
#  style          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  explanation    :string(255)
#  is_required    :boolean          default(FALSE)
#  deleted_at     :datetime
#  position       :integer          default(0)
#

require 'spec_helper'

describe Question do
  let(:question) { create(:long_answer_question) }

  it "should create a new instance given valid attributes" do
    question.should be_valid
  end
  
  it { should respond_to :custom_form }
  it { should respond_to :predefined_answers }
  
  describe "body" do
    it "should required" do
      build(:long_answer_question, :body => nil).should_not be_valid
    end
    
    it "should validate is within size limit" do
      build(:long_answer_question, :body => "1234567890123456789012345678901234567890123456789012345678901").should_not be_valid
    end
  end
  
  describe "explanation" do
    it "should not required" do
      build(:long_answer_question, :explanation => nil).should be_valid
    end
    
    it "should validate is within size limit" do
      build(:long_answer_question, :explanation => "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901").should_not be_valid
    end
  end
  
  describe "style" do   
    it "should be required" do
      build(:long_answer_question, :style => nil).should_not be_valid
    end
    
    it "can be set to valid styles" do
      Question::VALID_STYLES.count.should eq 5
      Question::VALID_STYLES.each do |style|
        build(:long_answer_question, :style => style).should be_valid
      end
    end
    
    it "can not be set to invalid styles" do
      INVALID_STYLES = %w(no_valid_style)
      INVALID_STYLES.each do |style|
        build(:long_answer_question, :style => style).should_not be_valid
      end
    end
  end
  
  describe "select_options" do
    it "should return all valid types with human readable form" do
      Question.select_options.count.should eq 5
      Question.select_options.first.count.should eq 2
    end
  end
  
  it "should not create blank predefined answers" do
    question = build(:select_box_question, :predefined_answers_attributes => [])
    question.predefined_answers_attributes = [{:body => "has body"}, {:body => ""}]
    question.save
    question.predefined_answers.count.should eq 1
    question.predefined_answers.first.body.should eq "has body"
  end
  
  describe "destroy" do
    it "should mark question as deleted" do
      question.destroy
      Question.exists?(question).should be_false
      Question.with_deleted.exists?(question).should be_true
    end
    
    it "should mark question's predefined_answers as deleted" do
      question = create(:select_box_question)
      predefined_answers = question.predefined_answers.all
      
      question.destroy
      predefined_answers.should_not be_empty
      predefined_answers.each do |predefined_answer|
        PredefinedAnswer.exists?(predefined_answer).should be_false
        PredefinedAnswer.with_deleted.exists?(predefined_answer).should be_true
      end
    end
  end
end
