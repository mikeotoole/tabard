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

  it "should require submission" do
    build(:answer, :submission => nil).should_not be_valid
  end
  
  it "should require body" do
    build(:answer, :body => nil).should_not be_valid
  end
end
