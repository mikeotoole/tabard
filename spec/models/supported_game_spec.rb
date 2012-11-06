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

describe CommunityGame do
  let(:community) { create(:community) }
  let(:wow) { DefaultObjects.wow }
  let(:community_game) { community.community_games.create!(:game => wow, :name => "Test Supported Game") }

  it "should create a new instance given valid attributes" do
    community_game.should be_valid
  end

  it "should require community" do
    community_game = CommunityGame.new(:game => wow, :name => "Test Supported Game")
    community_game.community = nil
    community_game.save
    community_game.should_not be_valid
  end

  it "should require game" do
    community_game = CommunityGame.new(:game => nil, :name => "Test Supported Game")
    community_game.community = community
    community_game.save
    community_game.should_not be_valid
    community_game = CommunityGame.new(:game => wow, :name => "Test Supported Game")
    community_game.community = community
    community_game.save
    community_game.should raise_error
  end

  describe "destroy" do
    it "should mark supported game as deleted" do
      community_game.destroy
      CommunityGame.exists?(community_game).should be_false
      CommunityGame.with_deleted.exists?(community_game).should be_true
    end

    it "should mark supported game's roster_assignments as deleted" do
      community_game = create(:roster_assignment).community_game
      roster_assignments = community_game.roster_assignments.all
      community_game.destroy
      roster_assignments.should_not be_empty
      roster_assignments.each do |roster_assignment|
        RosterAssignment.exists?(roster_assignment).should be_false
        RosterAssignment.with_deleted.exists?(roster_assignment).should be_true
      end
    end

    it "should mark supported game's announcements as deleted" do
      community_game = create(:announcement_for_wow).community_game
      announcements = community_game.announcements.all
      community_game.destroy
      announcements.should_not be_empty
      announcements.each do |announcement|
        Announcement.exists?(announcement).should be_false
        Announcement.with_deleted.exists?(announcement).should be_true
      end
    end

    it "should mark supported game's discussion_spaces as deleted" do
      community_game = create(:discussion_space_for_wow).community_game
      discussion_spaces = community_game.discussion_spaces.all
      community_game.destroy
      discussion_spaces.should_not be_empty
      discussion_spaces.each do |discussion_space|
        DiscussionSpace.exists?(discussion_space).should be_false
        DiscussionSpace.with_deleted.exists?(discussion_space).should be_true
      end
    end

    it "should mark supported game's page_spaces as deleted" do
      community_game = create(:page_space_for_wow).community_game
      page_spaces = community_game.page_spaces.all
      community_game.destroy
      page_spaces.should_not be_empty
      page_spaces.each do |page_space|
        PageSpace.exists?(page_space).should be_false
        PageSpace.with_deleted.exists?(page_space).should be_true
      end
    end
  end
end
