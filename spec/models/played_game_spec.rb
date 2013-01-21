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

require 'spec_helper'

describe PlayedGame do
  describe "game" do
    it "should be required" do
      build(:wow_played_game, game: nil).should_not be_valid
    end
  end
end
