class SupportedGame < ActiveRecord::Base
  attr_accessible :community, :game
  belongs_to :community
  belongs_to :game
end

# == Schema Information
#
# Table name: supported_games
#
#  id           :integer         not null, primary key
#  community_id :integer
#  game_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

