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
#  is_removed     :boolean
#

require 'spec_helper'

describe SwtorCharacter do
  let(:swtor_character) { create(:swtor_character) }
  let(:empire_game) { DefaultObjects.swtor }
  let(:republic_game) { create(:swtor, :faction => "Republic") }

  it "should create a new instance given valid attributes" do
    swtor_character.should be_valid
  end

  describe "advanced_class" do
    it "should be required" do
      build(:swtor_character, :advanced_class => nil).should_not be_valid
    end

    it "should validate advanced_class exists for char_class" do
      build(:swtor_character, :advanced_class => "Not an advanced class").should_not be_valid
    end
  end

  describe "species" do
    it "should be required" do
       build(:swtor_character, :species => nil).should_not be_valid
    end

    it "should validate species exists for advanced_class" do
      build(:swtor_character, :species => "Not a species").should_not be_valid
      build(:swtor_character, :advanced_class => "Juggernaut", :species => "Rattataki").should_not be_valid
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
end

