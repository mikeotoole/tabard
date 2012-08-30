class CommunityUserPackUpgrade < CommunityUpgrade
  def number_of_bonus_users(community)
    match = self.current_community_upgrades.find_by_community_id(community.id)
    return 0 if match.blank?
    self.upgrade_options[:number_of_users] * match.number_in_use
  end
end