class CurrentCommunityUpgrade < ActiveRecord::Base
  attr_accessible :community_upgrade_id, :number_in_use
  belongs_to :community, inverse_of: :current_community_upgrades
  belongs_to :community_upgrade, inverse_of: :current_community_upgrades

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
end

# == Schema Information
#
# Table name: current_community_upgrades
#
#  id                           :integer          not null, primary key
#  community_id                 :integer
#  community_upgrade_id         :integer
#  number_in_use                :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  current_plan_expiration_date :date
#  subcription_amount           :integer
#

