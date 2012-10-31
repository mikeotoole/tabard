# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe SwtorCharacter do
  let(:swtor_character) { create(:swtor_character) }
  let(:empire_game) { DefaultObjects.swtor }
  let(:republic_game) { create(:swtor, :faction => "Republic") }

  it "should create a new instance given valid attributes" do
    swtor_character.should be_valid
  end

  describe "char_class" do
    it "should be required" do
      build(:swtor_character, :char_class => nil).should_not be_valid
    end

    it "should validate char_class exists for faction" do
      build(:swtor_character, :char_class => "Not a class").should_not be_valid
      build(:swtor_character, :swtor => empire_game, :char_class => "Jedi Knight").should_not be_valid
      build(:swtor_character, :swtor => republic_game, :char_class => "Sith Warrior").should_not be_valid
    end
  end

  describe "advanced_class" do
    it "should be required" do
      build(:swtor_character, :advanced_class => nil).should_not be_valid
    end
    
    it "should validate advanced_class exists for char_class" do
      build(:swtor_character, :advanced_class => "Not an advanced class").should_not be_valid
      build(:swtor_character, :swtor => empire_game, :char_class => "Sith Warrior", :advanced_class => "Powertech").should_not be_valid
    end
  end

  describe "species" do
    it "should be required" do
       build(:swtor_character, :species => nil).should_not be_valid
    end
    
    it "should validate species exists for advanced_class" do
      build(:swtor_character, :species => "Not a species").should_not be_valid
      build(:swtor_character, :swtor => empire_game, :char_class => "Sith Warrior", :advanced_class => "Juggernaut", :species => "Rattataki").should_not be_valid
    end
  end
  
  describe "gender" do
    it "should be required" do
       build(:swtor_character, :gender => nil).should_not be_valid
    end
    
    it "should validate gender is valid" do
      build(:swtor_character, :gender => "Not a gender").should_not be_valid
      build(:swtor_character, :gender => "Female").should be_valid
      build(:swtor_character, :gender => "Male").should be_valid
    end
  end
  
  describe "game" do 
    it "should return swtor game" do
      swtor_character.game.should be_a(Swtor)
    end
    
    it "should be required" do
      build(:swtor_character, :swtor => nil).should_not be_valid
    end
    
    it "should reject non-Swtor type game" do
      assert_raises(ActiveRecord::AssociationTypeMismatch) do
        build(:swtor_character, :swtor => DefaultObjects.wow)
      end
    end
    
    it "should accept Swtor type game" do
      build(:swtor_character, :swtor => DefaultObjects.swtor).should be_valid
    end
  end
  
  it "should have SWTOR Character description" do
    swtor_character.description.should eq("SWTOR Character")
  end
end
 
