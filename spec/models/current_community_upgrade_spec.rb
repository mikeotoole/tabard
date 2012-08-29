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

require 'spec_helper'

describe CurrentCommunityUpgrade do
  pending "add some examples to (or delete) #{__FILE__}"
end
