# == Schema Information
#
# Table name: community_plans
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  description              :text
#  price_per_month_in_cents :integer
#  is_available             :boolean          default(TRUE)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  max_number_of_users      :integer          default(0)
#

require 'spec_helper'

describe CommunityPlan do
  let(:community_plan) { create(:community_plan) }
  let(:pro_community_plan) { create(:pro_community_plan) }
  let(:free_community_plan) { create(:free_community_plan) }

  it "should create a new instance given valid attributes" do
    community_plan.should be_valid
    pro_community_plan.should be_valid
    free_community_plan.should be_valid
  end

  it "should be pro when pro" do
    pro_community_plan.is_free_plan?.should be_false
    pro_community_plan.price_per_month_in_cents.should be > 0
    pro_community_plan.max_number_of_users.should be > 20
  end

  describe "title" do
    it "should not be blank" do
      build(:community_plan, title: "").should_not be_valid
      build(:community_plan, title: nil).should_not be_valid
    end

    it "should not be changable for free plan" do
      free_community_plan.is_free_plan?.should be_true
      free_community_plan.title = "New title"
      free_community_plan.save.should be_false
      free_community_plan.errors.full_messages.first.should include("Title can not be changed on free plan.")
    end

    it "should be changable for paid plans" do
      pro_community_plan.is_free_plan?.should be_false
      pro_community_plan.title = "New title"
      pro_community_plan.save.should be_true
      CommunityPlan.find(pro_community_plan).title.should eq "New title"
    end
  end

  describe "description" do
    it "should not be blank" do
      build(:community_plan, description: "").should_not be_valid
      build(:community_plan, description: nil).should_not be_valid
    end
  end

  describe "price_per_month_in_cents" do
    it "should not be blank" do
      build(:community_plan, price_per_month_in_cents: nil).should_not be_valid
    end

    it "should not be negative" do
      build(:community_plan, price_per_month_in_cents: -1).should_not be_valid
    end

    it "should only allow integer" do
      build(:community_plan, price_per_month_in_cents: 1.11).should_not be_valid
    end

    it "should not be changable" do
      community_plan.price_per_month_in_cents = 200
      community_plan.save.should be_false
      community_plan.errors.full_messages.first.should eq "Price per month in cents can not be changed"
    end
  end
end
