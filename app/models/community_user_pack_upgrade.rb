class CommunityUserPackUpgrade < CommunityUpgrade
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

