# == Schema Information
#
# Table name: character_proxies
#
#  id                :integer         not null, primary key
#  user_profile_id   :integer
#  character_id      :integer
#  character_type    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  default_character :boolean         default(FALSE)
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
  
  describe "default_character" do
    it "updated from true to false should not be allowed" do
      firstProxy = create(:character_proxy)
      secondProxy = create(:character_proxy)
      firstProxy.default_character.should be_true
      secondProxy.default_character.should be_false
      firstProxy_id = firstProxy.id
      secondProxy_id = secondProxy.id
      
      firstProxy.update_attributes(:default_character => false)
      CharacterProxy.find(firstProxy_id).default_character.should be_true
      CharacterProxy.find(secondProxy_id).default_character.should be_false
    end
  
    it "updated from false to true should unset previous default" do
      firstProxy = create(:character_proxy)
      secondProxy = create(:character_proxy)
      firstProxy.default_character.should be_true
      secondProxy.default_character.should be_false
      firstProxy_id = firstProxy.id
      secondProxy_id = secondProxy
      
      secondProxy.update_attributes(:default_character => true)
      CharacterProxy.find(firstProxy_id).default_character.should be_false
      CharacterProxy.find(secondProxy_id).default_character.should be_true
    end
   end
  
  it "was default and deleted should set first for game as default" do
      firstProxy = create(:character_proxy)
      secondProxy = create(:character_proxy)
      firstProxy.default_character.should be_true
      secondProxy.default_character.should be_false
      secondProxy_id = secondProxy
      
      firstProxy.destroy.should be_true
      CharacterProxy.find(secondProxy_id).default_character.should be_true
  end
  
  it "should delete character when destroyed" do
    character = create(:wow_char_profile)
    character.should be_valid
    character.character_proxy.should be_valid
    character.character_proxy.destroy.should be_true
    WowCharacter.exists?(character).should be_false
  end

###
# Class Method Tests
###

  it "all_characters should return all characters" do
    billy = create(:billy)
    CharacterProxy.all_characters.count.should 
      eq(billy.user_profile.character_proxies.count)
  end
  
  it "character_user_profile should return the user profile for the character" do
    character = create(:wow_char_profile)
    user_profile = CharacterProxy.character_user_profile(character)
    user_profile.id.should eq(DefaultObjects.user_profile.id)
  end

end
