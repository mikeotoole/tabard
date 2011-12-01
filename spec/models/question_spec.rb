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

describe Question do
  let(:question) { create(:long_answer_question) }

  it "should create a new instance given valid attributes" do
    question.should be_valid
  end

  it "should require body" do
    build(:long_answer_question, :body => nil).should_not be_valid
  end

  it "should require style" do
    build(:long_answer_question, :style => nil).should_not be_valid
  end
  
  subject { @question = question }
  
  it { should respond_to :custom_form }
  it { should respond_to :answers }
  
  describe "type" do
    it "should be set to subclass name" do
      question.type.should eq("TextQuestion")
    end
    
    it "should be required" do
      build(:long_answer_question, :type => nil).should_not be_valid
    end
    
    it "shouldn't be editable" do
      question.update_attributes(:type => "SingleSelectQuestion").should be_true
      Question.find(question).type.should eq("TextQuestion")
    end
  end

  describe "type_style" do
    it "should properly decode this value" do
      some_question = Question.new(:body => "Herp!", :type_style => Question.all_select_options.first[1])
      some_question.should be_valid
    end
    it "should not be valid if type_style not valid" do
      some_question = Question.new(:body => "Herp!", :type_style => "lololol|derp")
      some_question.should_not be_valid
    end
  end
  
  it "all_select_options should return all valid question types" do
    Question.all_select_options.count.should eq(5)
  end
  
  describe "new_question" do
    it "should return a new question instance of each style with nil attributes hash" do
      question1 = Question.new_question("TextQuestion|long_answer_question", nil)
      question1.style.should eq("long_answer_question")
      question1.class.to_s.should eq("TextQuestion")
      question1 = Question.new_question("MultiSelectQuestion|check_box_question", nil)
      question1.style.should eq("check_box_question")
      question1.class.to_s.should eq("MultiSelectQuestion")
      question1 = Question.new_question("SingleSelectQuestion|select_box_question", nil)
      question1.style.should eq("select_box_question")
      question1.class.to_s.should eq("SingleSelectQuestion")
    end
    
    it "should return a valid new question given valid attributes hash" do
      question1 = Question.new_question("TextQuestion|long_answer_question", attributes_for(:long_answer_question))
      question1.style.should eq("long_answer_question")
      question1.class.to_s.should eq("TextQuestion")
      question1.should be_valid
      question1.save.should be_true
    end
    
    it "should return nil with invalid class name" do
      Question.new_question("NotQuestion|long_answer_question").should be_nil
    end
    
    it "should return nil with nil class_style_string" do
      Question.new_question(nil, attributes_for(:long_answer_question)).should be_nil
    end
    
    it "should return nil with invalid attributes hash" do
      Question.new_question("TextQuestion|long_answer_question", "Not a hash").should be_nil
    end
    
    it "should return nil with invalid class_style_string type" do
      Question.new_question(100).should be_nil
    end
  end
end
