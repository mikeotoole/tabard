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
#

require 'spec_helper'

describe CommunityPlan do
  let(:community_plan) { create(:community_plan) }
  it "should create a new instance given valid attributes" do
    community_plan.should be_valid
  end
  describe "title" do
    it "should not be blank" do
      build(:community_plan, title: "").should_not be_valid
      build(:community_plan, title: nil).should_not be_valid
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
  end
end
