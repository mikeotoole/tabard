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

describe WowCharacter do
  let(:wow_character) { create(:wow_character) }
  let(:alliance_game) { DefaultObjects.wow }
  let(:horde_game) { create(:wow, :faction => "Horde") }

  it "should create a new instance given valid attributes" do
    wow_character.should be_valid
  end

  describe "char_class" do
    it "should be required" do
      build(:wow_character, :char_class => nil).should_not be_valid
    end

    it "should validate char_class exists" do
      build(:wow_character, :char_class => "Not a class").should_not be_valid
    end
  end

  describe "race" do
    it "should be required" do
       build(:wow_character, :race => nil).should_not be_valid
    end

    it "should validate race exists for char_class and faction" do
      build(:wow_character, :race => "Not a race").should_not be_valid
      build(:wow_character, :wow => horde_game, :char_class => "Druid", :race => "Worgen").should_not be_valid
      build(:wow_character, :wow => alliance_game, :char_class => "Druid", :race => "Troll").should_not be_valid
    end
  end

  describe "gender" do
    it "should be required" do
       build(:wow_character, :gender => nil).should_not be_valid
    end

    it "should validate gender is valid" do
      build(:wow_character, :gender => "Not a gender").should_not be_valid
      build(:wow_character, :gender => "Female").should be_valid
      build(:wow_character, :gender => "Male").should be_valid
    end
  end

  describe "game" do
    it "should return wow game" do
      wow_character.game.should be_a(Wow)
    end

    it "should be required" do
      build(:wow_character, :wow => nil).should_not be_valid
    end

    it "should reject non-Wow type game" do
      assert_raises(ActiveRecord::AssociationTypeMismatch) do
        build(:wow_character, :wow => DefaultObjects.swtor)
      end
    end

    it "should accept Wow type game" do
      build(:wow_character, :wow => DefaultObjects.wow).should be_valid
    end
  end

  it "should have WoW Character description" do
    wow_character.description.should eq("WoW Character")
  end
end

