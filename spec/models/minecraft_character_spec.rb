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

describe MinecraftCharacter do
  let(:minecraft_character) { create(:minecraft_character) }

  it "should create a new instance given valid attributes" do
    minecraft_character.should be_valid
  end

  describe "name" do
    it "should be required" do
      build(:minecraft_character, :name => nil).should_not be_valid
    end
  end
  
  it "should have Minecraft Character description" do
    minecraft_character.description.should eq("Minecraft Character")
  end
end
 
