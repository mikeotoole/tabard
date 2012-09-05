class CommunityUserPackUpgrade < CommunityUpgrade
  def total_bonus_users(community)
    match = self.current_community_upgrades.find_by_community_id(community.id)
    return 0 if match.blank?
    self.upgrade_options[:number_of_users] * match.number_in_use
  end
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

