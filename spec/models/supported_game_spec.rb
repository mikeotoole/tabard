# == Schema Information
#
# Table name: supported_games
#
#  id                         :integer         not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  game_announcement_space_id :integer
#  name                       :string(255)
#  game_type                  :string(255)
#  deleted_at                 :datetime
#

require 'spec_helper'

describe SupportedGame do
  let(:community) { create(:community) }
  let(:wow) { DefaultObjects.wow }

  it "should create a new instance given valid attributes" do
    supported_game = SupportedGame.create(:game_id => wow.id, :game_type => "Wow", :name => "Test Supported Game")
    supported_game.community = community
    supported_game.save
    supported_game.should be_valid
  end
  
  it "should require community" do
    supported_game = SupportedGame.create(:game_id => wow.id, :game_type => "Wow", :name => "Test Supported Game")
    supported_game.community = nil
    supported_game.save
    supported_game.should_not be_valid
  end
  
  it "should require game" do
    supported_game = SupportedGame.create(:game_id => nil, :game_type => "Wow", :name => "Test Supported Game")
    supported_game.community = community
    supported_game.save
    supported_game.should_not be_valid
    supported_game = SupportedGame.create(:game_id => wow.id, :game_type => nil, :name => "Test Supported Game")
    supported_game.community = community
    supported_game.save
    supported_game.should raise_error
  end

  it "should require name" do
    supported_game = SupportedGame.create(:game_id => wow.id, :game_type => "Wow", :name => nil)
    supported_game.community = community
    supported_game.save
    supported_game.should_not be_valid
  end
end
