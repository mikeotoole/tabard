class CommunityUserPackUpgrade < CommunityUpgrade
  def number_of_bonus_users
    self.upgrade_options[:number_of_users]
  end
end