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
      build(:wow_character, :faction => "Horde", :char_class => "Druid", :race => "Worgen").should_not be_valid
      build(:wow_character, :faction => "Alliance", :char_class => "Druid", :race => "Troll").should_not be_valid
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
end

