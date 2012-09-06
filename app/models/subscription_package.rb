class SubscriptionPackage < ActiveRecord::Base
  attr_accessible :community_plan_id, :end_date, :current_community_upgrades_attributes
  before_save :ensure_full_package_time
  belongs_to :community_plan
  has_one :community, foreign_key: "current_subscription_package_id"
  has_many :current_community_upgrades, inverse_of: :subscription_package
  has_many :community_upgrades, through: :current_community_upgrades
  accepts_nested_attributes_for :current_community_upgrades, :allow_destroy => true, :reject_if => proc { |attributes| attributes['number_in_use'].blank? or attributes['number_in_use'].to_i <= 0 }

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

  def ensure_full_package_time
    # TODO take upgrades into account
    if self.community_plan_id_changed?
      old_plan = CommunityPlan.find_by_id(self.community_plan_id_was)
      new_plan = CommunityPlan.find_by_id(self.community_plan_id)
      if not old_plan.blank? and old_plan.price_per_month_in_cents > new_plan.price_per_month_in_cents
        # TODO Add end date
        old_package = SubscriptionPackage.create(community_plan_id: self.community_plan_id)
        self.community.update_column(:recurring_subscription_package_id, old_package.id)
        CurrentCommunityUpgrade.where(subscription_package_id: self.id).update_all(subscription_package_id: old_package.id)

        self.community_plan_id = self.community_plan_id_was
      end
    end
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

