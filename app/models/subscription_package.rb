class SubscriptionPackage < ActiveRecord::Base
  attr_accessible :community_plan_id, :end_date, :current_community_upgrades_attributes
  belongs_to :community_plan
  has_one :community, foreign_key: "current_subscription_package_id"
  has_many :current_community_upgrades, inverse_of: :subscription_package
  has_many :community_upgrades, through: :current_community_upgrades
  accepts_nested_attributes_for :current_community_upgrades, :allow_destroy => true, :reject_if => proc { |attributes| attributes['number_in_use'].blank? or attributes['number_in_use'].to_i <= 0 }

  delegate :title, to: :community_plan, prefix: true
  def has_expired?
    false
  end

  # Total price for this communities plans and upgrades in cents.
  def total_price_per_month_in_cents
    price = self.community_plan.price_per_month_in_cents
    self.current_community_upgrades.each do |current_community_upgrade|
      price = price + current_community_upgrade.total_price_per_month_in_cents
    end
    price
  end

  # The number of additional members allowed from upgrades.
  def user_pack_upgrade_amount
    total_bonus_users = 0
    self.community_upgrades.where{type == "CommunityUserPackUpgrade"}.each do |upgrade|
      if upgrade.is_a? CommunityUserPackUpgrade
        total_bonus_users = total_bonus_users + upgrade.total_bonus_users(self)
      end
    end
    return total_bonus_users
  end

  ###
  # The max number of users allowed in this community.
  # This includes plan and upgrade amounts.
  ###
  def max_number_of_users
    return self.community_plan.max_number_of_users + self.user_pack_upgrade_amount
  end

  def expired?
    self.end_date < Date.today
  end
end

# == Schema Information
#
# Table name: subscription_packages
#
#  id                :integer          not null, primary key
#  community_plan_id :integer
#  end_date          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

