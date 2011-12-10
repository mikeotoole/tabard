# == Schema Information
#
# Table name: page_spaces
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  supported_game_id :integer
#  community_id      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  deleted_at        :datetime
#

require 'spec_helper'

describe PageSpace do
  let(:space) { create(:page_space) }
  let(:wow_space) { create(:page_space_for_wow) }

  it "should create a new instance given valid attributes" do
    space.should be_valid
  end

  it "should require name" do
    build(:page_space, :name => nil).should_not be_valid
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
    wow_space.game_name.should eq(DefaultObjects.wow.name)
  end
end
