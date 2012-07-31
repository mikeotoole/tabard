# == Schema Information
#
# Table name: supported_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  game_announcement_space_id :integer
#  name                       :string(255)
#  game_type                  :string(255)
#  deleted_at                 :datetime
#

require 'spec_helper'

describe SupportedGame do
  let(:community) { create(:community) }
  let(:wow) { DefaultObjects.wow }
  let(:supported_game) { community.supported_games.create!(:game_id => wow.id, :game_type => "Wow", :name => "Test Supported Game") }

  it "should create a new instance given valid attributes" do
    supported_game.should be_valid
  end

  it "should require community" do
    supported_game = SupportedGame.new(:game_id => wow.id, :game_type => "Wow", :name => "Test Supported Game")
    supported_game.community = nil
    supported_game.save
    supported_game.should_not be_valid
  end
  
  it "should require game" do
    supported_game = SupportedGame.new(:game_id => nil, :game_type => "Wow", :name => "Test Supported Game")
    supported_game.community = community
    supported_game.save
    supported_game.should_not be_valid
    supported_game = SupportedGame.new(:game_id => wow.id, :game_type => nil, :name => "Test Supported Game")
    supported_game.community = community
    supported_game.save
    supported_game.should raise_error
  end

  it "should require name" do
    supported_game = SupportedGame.new(:game_id => wow.id, :game_type => "Wow", :name => nil)
    supported_game.community = community
    supported_game.save
    supported_game.should_not be_valid
  end
  
  describe "destroy" do
    it "should mark supported game as deleted" do
      supported_game.destroy
      SupportedGame.exists?(supported_game).should be_false
      SupportedGame.with_deleted.exists?(supported_game).should be_true
    end
    
    it "should mark supported game's roster_assignments as deleted" do
      supported_game = create(:roster_assignment).supported_game
      roster_assignments = supported_game.roster_assignments.all
      supported_game.destroy
      roster_assignments.should_not be_empty
      roster_assignments.each do |roster_assignment|
        RosterAssignment.exists?(roster_assignment).should be_false
        RosterAssignment.with_deleted.exists?(roster_assignment).should be_true
      end
    end
    
    it "should mark supported game's announcements as deleted" do
      supported_game = create(:announcement_for_wow).supported_game
      announcements = supported_game.announcements.all
      supported_game.destroy
      announcements.should_not be_empty
      announcements.each do |announcement|
        Announcement.exists?(announcement).should be_false
        Announcement.with_deleted.exists?(announcement).should be_true
      end
    end
    
    it "should mark supported game's discussion_spaces as deleted" do
      supported_game = create(:discussion_space_for_wow).supported_game
      discussion_spaces = supported_game.discussion_spaces.all
      supported_game.destroy
      discussion_spaces.should_not be_empty
      discussion_spaces.each do |discussion_space|
        DiscussionSpace.exists?(discussion_space).should be_false
        DiscussionSpace.with_deleted.exists?(discussion_space).should be_true
      end
    end
    
    it "should mark supported game's page_spaces as deleted" do
      supported_game = create(:page_space_for_wow).supported_game
      page_spaces = supported_game.page_spaces.all
      supported_game.destroy
      page_spaces.should_not be_empty
      page_spaces.each do |page_space|
        PageSpace.exists?(page_space).should be_false
        PageSpace.with_deleted.exists?(page_space).should be_true
      end
    end
  end
end
