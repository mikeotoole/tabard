# == Schema Information
#
# Table name: discussion_spaces
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  supported_game_id     :integer
#  community_id          :integer
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  is_announcement_space :boolean         default(FALSE)
#  deleted_at            :datetime
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

  it "game_name should return nil if there is no game" do
    space.game_name.should be_nil
  end 
  
  it "game_name should return game name if there is a game" do
    wow_space.game_name.should eq(wow_space.supported_game.full_name)
  end 
  
  it "should respond to is_announcement_space" do
    wow_space.should respond_to(:is_announcement_space)
  end
  
  it "should not allow access to is_announcement_space flag" do
    wow_space.update_attributes(:is_announcement_space => true).should be_true
    DiscussionSpace.find(wow_space).is_announcement_space.should be_false
  end
  
  describe "destroy" do
    it "should mark discussion_space as deleted" do
      space.destroy
      DiscussionSpace.exists?(space).should be_false
      DiscussionSpace.with_deleted.exists?(space).should be_true
    end
    
    it "should mark discussion_space's discussions as deleted" do
      discussion = create(:discussion)
      space = discussion.discussion_space
      
      space.destroy
      Discussion.exists?(discussion).should be_false
      Discussion.with_deleted.exists?(discussion).should be_true
    end
  end
end
