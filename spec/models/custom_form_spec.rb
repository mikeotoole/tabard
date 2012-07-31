# == Schema Information
#
# Table name: custom_forms
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  instructions :text
#  thankyou     :string(255)
#  is_published :boolean          default(FALSE)
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#

require 'spec_helper'

describe CustomForm do
  let(:form) { create(:custom_form) }

  it "should create a new instance given valid attributes" do
    form.should be_valid
  end

  it "should require name" do
    build(:custom_form, :name => nil).should_not be_valid
  end

  it "should not require instructions" do
    build(:custom_form, :instructions => nil).should be_valid
  end

  it "should require thankyou" do
    build(:custom_form, :thankyou => nil).should_not be_valid
  end

  it "should require community" do
    build(:custom_form, :community => nil).should_not be_valid
  end

  describe "community_name" do
    it "should return community name string" do
      form.community_name.should eq(DefaultObjects.community.name)
    end
  end

  describe "destroy" do
    it "should mark custom_form as deleted" do
      form.destroy
      CustomForm.exists?(form).should be_false
      CustomForm.with_deleted.exists?(form).should be_true
    end

    it "should mark custom_form's submissions as deleted" do
      submission = create(:submission)
      custom_form = submission.custom_form
      custom_form.submissions.count.should eq 1

      custom_form.destroy
      Submission.exists?(submission).should be_false
      Submission.with_deleted.exists?(submission).should be_true
    end

    it "should mark custom_form's questions as deleted" do
      question = create(:short_answer_question)
      custom_form = question.custom_form

      custom_form.destroy
      Question.exists?(question).should be_false
      Question.with_deleted.exists?(question).should be_true
    end
    it "should not allow community application for to be deleted" do
      community = create(:community)
      community = community.reload
      app = community.community_application_form
      app.destroy
      CustomForm.exists?(app).should be_true
    end
  end
end
