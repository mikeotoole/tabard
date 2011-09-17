require 'spec_helper'

describe Answer do
  let(:answer) { Factory.create(:answer) }

  it "should create a new instance given valid attributes" do
    answer.should be_valid
  end
  
  it "should require question" do
    build(:answer, :question => nil).should_not be_valid
  end

  it "should require submission" do
    build(:answer, :submission => nil).should_not be_valid
  end
  
  it "should require body" do
    build(:answer, :body => nil).should_not be_valid
  end
end