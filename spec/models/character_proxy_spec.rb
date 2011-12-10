# == Schema Information
#
# Table name: character_proxies
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  character_id    :integer
#  character_type  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe CharacterProxy do

  it "should create a new instance given valid attributes" do
    create(:character_proxy).should be_valid
  end

  it "should require user_profile" do
    build(:character_proxy, :user_profile => nil).should_not be_valid
  end

  it "should require character" do
    build(:character_proxy, :character => nil).should_not be_valid
  end
  
  it "should mark character as removed character when destroyed" do
    character = create(:wow_char_profile)
    character.should be_valid
    character.character_proxy.should be_valid
    character.character_proxy.destroy.should be_true
    WowCharacter.find(character).is_removed.should be_true
  end

###
# Class Method Tests
###

  it "all_characters should return all characters" do
    billy = create(:billy)
    CharacterProxy.all_characters.count.should 
      eq(billy.user_profile.character_proxies.count)
  end
end
