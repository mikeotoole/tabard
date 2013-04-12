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
    it "should be required" do
      build(:wow_played_game, game_id: nil).should_not be_valid
    end
  end
  it "should remove unused custom games after deletion if no more played games" do
    some_game_name = 'herpatron'
    single_played_game = DefaultObjects.user_profile.played_games.create(game_name: some_game_name)
    CustomGame.find_by_name(some_game_name).should_not eq nil
    single_played_game.destroy
    CustomGame.find_by_name(some_game_name).should eq nil
  end
  it "should not remove unused custom games after deletion if no more played games" do
    some_game_name = 'herpatron'
    create(:user_profile).played_games.create(game_name: some_game_name)
    single_played_game = DefaultObjects.user_profile.played_games.create(game_name: some_game_name)
    CustomGame.find_by_name(some_game_name).should_not eq nil
    single_played_game.destroy
    CustomGame.find_by_name(some_game_name).should_not eq nil
  end
end
