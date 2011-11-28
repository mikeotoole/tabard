# == Schema Information
#
# Table name: swtor_characters
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  swtor_id       :integer
#  avatar         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  char_class     :string(255)
#  advanced_class :string(255)
#  species        :string(255)
#  level          :string(255)
#  about          :string(255)
#

require 'spec_helper'

describe SwtorCharacter do
  let(:swtor_character) { Factory.create(:swtor_character) }

  it "should create a new instance given valid attributes" do
    swtor_character.should be_valid
  end
  
  describe "game" do 
    it "should return swtor game" do
      swtor_character.game.should be_a(Swtor)
    end
    
    it "should be required" do
      Factory.build(:swtor_character, :swtor => nil).should_not be_valid
    end
    
    it "should reject non-Swtor type game" do
      assert_raises(ActiveRecord::AssociationTypeMismatch) do
        Factory.build(:swtor_character, :swtor => DefaultObjects.wow)
      end
    end
    
    it "should accept Swtor type game" do
      Factory.build(:swtor_character, :swtor => DefaultObjects.swtor).should be_valid
    end
  end
  
  it "should have SWTOR Character description" do
    swtor_character.description.should eq("SWTOR Character")
  end
end
 
