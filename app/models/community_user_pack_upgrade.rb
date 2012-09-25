###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# An upgrade that gives a community more allowed users.
###
class CommunityUserPackUpgrade < CommunityUpgrade
  has_many :invoice_items, as: :item
###
# Public Methods
###

###
# Instance Methods
###
  # Returns the total number of bonus users the given community has.
  def total_bonus_users(subscription_package)
    match = self.current_community_upgrades.find_by_subscription_package_id(subscription_package.id)
    return 0 if match.blank?
    self.upgrade_options[:number_of_users] * match.number_in_use
  end

  # Returns the number of allowed users per upgrade.
  def number_of_bonus_users
    self.upgrade_options[:number_of_users]
  end
end

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

