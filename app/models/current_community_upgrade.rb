class CurrentCommunityUpgrade < ActiveRecord::Base
  attr_accessible :community_upgrade_id, :number_in_use
  belongs_to :community, inverse_of: :current_community_upgrades
  belongs_to :community_upgrade, inverse_of: :current_community_upgrades
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

