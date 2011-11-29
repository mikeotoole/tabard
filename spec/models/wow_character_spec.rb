# == Schema Information
#
# Table name: wow_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  faction    :string(255)
#  race       :string(255)
#  level      :integer
#  server     :string(255)
#  game_id    :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe WowCharacter do
  let(:wow_character) { create(:wow_character) }

  it "should create a new instance given valid attributes" do
    wow_character.should be_valid
  end
  
  describe "game" do 
    it "should return wow game" do
      wow_character.game.type.should eq("Wow")
    end
    
    it "should be required" do
      build(:wow_character, :game => nil).should_not be_valid
      build(:wow_character, :wow => nil).should_not be_valid
    end
    
    it "should reject non-Wow type game" do
      build(:wow_character, :game => DefaultObjects.swtor).should_not be_valid
      assert_raises(ActiveRecord::AssociationTypeMismatch) do
        build(:wow_character, :wow => DefaultObjects.swtor)
      end
    end
    
    it "should accept Wow type game" do
      build(:wow_character, :game => DefaultObjects.wow).should be_valid
      build(:wow_character, :wow => DefaultObjects.wow).should be_valid
    end
  end
  
  it "should have WoW Character description" do
    wow_character.description.should eq("WoW Character")
  end
end
 
