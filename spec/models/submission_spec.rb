# == Schema Information
#
# Table name: submissions
#
#  id              :integer          not null, primary key
#  custom_form_id  :integer
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#

require 'spec_helper'

describe Submission do
  let(:submission) { create(:submission) }

  it "should create a new instance given valid attributes" do
    submission.should be_valid
  end

  it "should require custom_form" do
    build(:submission, :custom_form => nil).should_not be_valid
  end

  it "should require user_profile" do
    build(:submission, :user_profile => nil).should_not be_valid
  end
  
  subject { @submission = submission }
  
  it { should respond_to :answers }
  it { should respond_to :community }
  it { should respond_to :form_questions }
  
  describe "community" do
    it "should return custom forms community" do
      submission.community.should eq(DefaultObjects.community)
    end
  end
  
  describe "name" do
    it "should return user_profile name" do
      submission.name.should eq(DefaultObjects.user_profile.name)
    end
  end
  
  describe "thankyou_message" do
    it "should return custom forms thank you message" do
      submission.thankyou_message.should eq(submission.custom_form.thankyou)
    end
  end
  
  describe "submission_date" do
    it "should return the date submission was submitted" do
      submission.submission_date.to_s[0,10].should eq(Time.zone.today.to_s)
    end
  end
  
  describe "all_answers" do
    it "should return all submission answers" do
      create(:submission_w_answers).answers.count.should eq(5)
    end
    
    it "should return 0 if submission has no answers" do
      submission.answers.count.should eq(0)
    end
  end
  
  describe "form_questions" do
    it "should return all custom_form questions" do
      submission = create(:submission_w_answers)
      submission.custom_form.questions.count.should eq 5
      submission.form_questions.count.should eq 5
    end
    
    it "should return 0 if custom_form has no questions" do
      submission.custom_form.questions.count.should eq 0
      submission.form_questions.count.should eq 0
    end
  end
end
