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

require 'spec_helper'

describe CurrentCommunityUpgrade do
  let(:current_community_upgrade) { create(:current_community_upgrade) }
  it "should create a new instance given valid attributes" do
    current_community_upgrade.should be_valid
  end
end
