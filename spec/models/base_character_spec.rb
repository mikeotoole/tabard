require 'spec_helper'

describe BaseCharacter do
  let(:character) { create(:wow_char_profile) }
  
  it "should not allow new instance of base class" do
    assert_raises(ActiveRecord::StatementInvalid) do
      BaseCharacter.new
    end
  end
  
  it "should require a name" do
    build(:wow_character, :name => nil).should_not be_valid
  end
  
  describe "avatars" do
    before(:all) do
      AvatarUploader.enable_processing = true
    end
    
    after(:all) do
      AvatarUploader.enable_processing = false
    end

    it "should reject invalid file sizes" do
      badFilenames = %w{ tooBigAvatar1.jpg } # TESTING Invalid avatar file size for testing
      badFilenames.each do |filename|
        build(:wow_character, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
      end  
    end
  end
  
  describe "character_id" do
    it "should be this characters id" do
      WowCharacter.find(character.id).should eq(character)
    end
  end
  
  describe "display_name" do   
    it "should be the characters name" do
      character.display_name.should eq(character.name)
    end
  end
  
  describe "default" do
    it "should be true when first character of game type is created" do
      character.default.should be_true
    end
    
    it "should be false by default on creation when default for game exists" do
      create(:wow_char_profile).default.should be_true
      create(:wow_char_profile).default.should be_false
    end
  end
  
  describe "set_as_default" do   
    it "should set character as default for game for user" do
      create(:wow_char_profile)
      character.default.should be_false
      character.set_as_default
      character.default.should be_true
    end
    
    it "should remove previous for game for user" do
      firstCharacter = create(:wow_char_profile)
      firstCharacter.default.should be_true
      firstCharacter_id = firstCharacter.id
      character.default.should be_false
      character_id = character.id
      character.set_as_default
      WowCharacter.find(character_id).default.should be_true
      WowCharacter.find(firstCharacter_id).default.should be_false
    end
  end
end
