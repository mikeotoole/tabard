class CurrentCommunityUpgrade < ActiveRecord::Base
  attr_accessible :community_upgrade_id, :number_in_use
  belongs_to :community, inverse_of: :current_community_upgrades
  belongs_to :community_upgrade, inverse_of: :current_community_upgrades

  validates :community_id, uniqueness: {scope: [:community_upgrade_id]}
  validate :upgrade_is_compatable

  before_save :update_amounts

  def update_amounts
    if number_in_use_changed?
      if not number_in_use_was.blank? and number_in_use_was > number_in_use
        self.subcription_amount = number_in_use_was
      else
        self.subcription_amount = number_in_use
      end
    else
      return true
    end
  end

  def current_amount
    return number_in_use if community.community_subscription_date.blank?
    if community.community_subscription_date > Time.now
      return number_in_use
    else
      return subcription_amount
    end
  end

  def total_price_per_month_in_cents
    unless self.marked_for_destruction?
      self.number_in_use * self.community_upgrade.price_per_month_in_cents
    else
      0
    end
  end

  def total_price_per_month_in_dollars
    self.total_price_per_month_in_cents/100.0
  end

  def upgrade_is_compatable
    unless self.community.community_plan.community_upgrades.include? self.community_upgrade
      errors.add(:community_upgrade, "is not compatable with the community's plan.")
      return false 
    end
  end
end

# == Schema Information
#
# Table name: current_community_upgrades
#
#  id                   :integer          not null, primary key
#  community_id         :integer
#  community_upgrade_id :integer
#  number_in_use        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  subcription_amount   :integer
#

