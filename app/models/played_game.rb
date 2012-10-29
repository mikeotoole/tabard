class PlayedGame < ActiveRecord::Base
  attr_accessible :game_id, :user_profile_id
  belongs_to :game
  belongs_to :user_profile
end

# == Schema Information
#
# Table name: played_games
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

