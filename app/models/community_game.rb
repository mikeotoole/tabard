class CommunityGame < ActiveRecord::Base
  attr_accessible :community_id, :game_announcement_space_id, :game_id, :info
end

# == Schema Information
#
# Table name: community_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  game_announcement_space_id :integer
#  info                       :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

