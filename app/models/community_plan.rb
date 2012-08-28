class CommunityPlan < ActiveRecord::Base

  has_many :communities
  has_many :community_plan_upgrades
  has_many :community_upgrades, through: :community_plan_upgrades

###
# Scopes
###
  scope :available, lambda {
    where{(is_available == true)}
  }

  def self.default_plan
    plan = CommunityPlan.find_by_title("Free")
    if plan == nil
      return CommunityPlan.create({
        title: "Free",
        description: "This is the default free plan.",
        price_per_month_in_cents: 0,
        is_available: true
        }, without_protection: true)
    else
      return plan
    end
  end
end

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

