# == Schema Information
#
# Table name: discussion_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  supported_game_i:integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  is_announcement :boolean         default(FALSE)
#

require 'spec_helper'

describe DiscussionSpace do
  let(:space) { create(:discussion_space) }
  let(:wow_space) { create(:discussion_space_for_wow) }

  it "should create a new instance given valid attributes" do
    space.should be_valid
  end

  it "should require name" do
    build(:discussion_space, :name => nil).should_not be_valid
  end

  it "should require community" do
    space.should be_valid
    space.community = nil
    space.save.should be_false
  end

  it "has_game_context? should return false if there is no game" do
    space.has_game_context?.should be_false
  end 
  
  it "has_game_context? should return true if there is a game" do
    wow_space.has_game_context?.should be_true
  end 

  it "game_name should return '' if there is no game" do
    space.game_name.should eq('')
  end 
  
  it "game_name should return game name if there is a game" do
    wow_space.game_name.should eq(DefaultObjects.wow.name)
  end 
  
  it "should respond to is_announcement" do
    wow_space.should respond_to(:is_announcement)
  end
  
  it "should not allow access to is_announcement flag" do
    wow_space.update_attributes(:is_announcement => true).should be_true
    DiscussionSpace.find(wow_space).is_announcement.should be_false
  end

  describe "game_is_valid_for_community" do
    it "should allow a community supported game" do
      build(:discussion_space, :game_id => DefaultObjects.wow.id).should be_valid  
    end
    it "should not allow a non-community supported game" do
      build(:discussion_space, :game_id => DefaultObjects.swtor.id).should_not be_valid  
    end
  end
end
