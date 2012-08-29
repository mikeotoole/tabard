class CurrentCommunityUpgrade < ActiveRecord::Base
  attr_accessible :community_upgrade_id, :number_in_use
  belongs_to :community
  belongs_to :community_upgrade

  def total_price_per_month_in_cents
    self.number_in_use * self.community_upgrade.price_per_month_in_cents
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
#

