# == Schema Information
#
# Table name: community_upgrades
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  description              :text
#  price_per_month_in_cents :integer
#  max_number_of_upgrades   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  type                     :string(255)
#  upgrade_options          :text
#

require 'spec_helper'

describe CommunityUpgrade do
  let(:community_upgrade) { create(:community_upgrade) }
  it "should create a new instance given valid attributes" do
    community_upgrade.should be_valid
  end
  describe "title" do
    it "should not be blank" do
      build(:community_upgrade, title: "").should_not be_valid
      build(:community_upgrade, title: nil).should_not be_valid
    end
  end
  describe "description" do
    it "should not be blank" do
      build(:community_upgrade, description: "").should_not be_valid
      build(:community_upgrade, description: nil).should_not be_valid
    end
  end

  describe "type" do
    it "should not be blank" do
      build(:community_upgrade, type: "").should_not be_valid
      build(:community_upgrade, type: nil).should_not be_valid
    end
    it "should have a limited inclusion set" do
      valid_types = %w{ CommunityUserPackUpgrade } # TESTING Valid types for testing.
      valid_types.each do |valid_type|
        build(:community_upgrade, type: valid_type).should be_valid
      end
      invalid_types = %w{ EVERYTHING_UPGRADE } # TESTING Invalid types for testing.
      invalid_types.each do |invalid_type|
        build(:community_upgrade, type: invalid_type).should_not be_valid
      end
    end
  end

  describe "price_per_month_in_cents" do
    it "should not be blank" do
      build(:community_upgrade, price_per_month_in_cents: nil).should_not be_valid
    end
    it "should not be negative" do
      build(:community_upgrade, price_per_month_in_cents: -1).should_not be_valid
    end
    it "should only allow integer" do
      build(:community_upgrade, price_per_month_in_cents: 1.11).should_not be_valid
    end
  end
  describe "max_number_of_upgrades" do
    it "should not be blank" do
      build(:community_upgrade, max_number_of_upgrades: nil).should_not be_valid
    end
    it "should not be negative" do
      build(:community_upgrade, max_number_of_upgrades: -1).should_not be_valid
    end
    it "should only allow integer" do
      build(:community_upgrade, max_number_of_upgrades: 1.11).should_not be_valid
    end
  end
end
