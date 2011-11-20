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
#

require 'spec_helper'

describe SupportedGame do
  let(:community) { create(:community) }
  let(:wow) { DefaultObjects.wow }

  it "should create a new instance given valid attributes" do
    SupportedGame.create(:community => community, :game => wow).should be_valid
  end
  
  it "should require community" do
    SupportedGame.create(:community => nil, :game => wow).should_not be_valid
  end
  
  it "should require game" do
    SupportedGame.create(:community => community, :game => nil).should_not be_valid
  end
  
  it "should create game specific announcement space on creation" do
    community.supported_games.should be_empty
    community.supported_games.create(:game => wow).should be_valid
    supported_game = community.supported_games.first
    supported_game.game_announcement_space.should be_a(DiscussionSpace)
    supported_game.game_announcement_space.is_announcement.should be_true
  end
    
  it "should destroy game specific announcement space on destruction" do
    SupportedGame.all.count.should eq(0)
    
    supported_game = community.supported_games.create(:game => wow)
    supported_game.should be_valid
    space = supported_game.game_announcement_space
    space.should be_a(DiscussionSpace)
    SupportedGame.all.count.should eq(1)
    
    community.supported_games.find_by_id(supported_game.id).destroy
    SupportedGame.all.count.should eq(0)
    SupportedGame.exists?(supported_game).should be_false
    Game.exists?(wow).should be_true
    DiscussionSpace.exists?(space).should be_false
  end
end
