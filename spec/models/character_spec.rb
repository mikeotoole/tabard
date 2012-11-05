require 'spec_helper'

describe Character do
  let(:character) { create(:wow_character) }

  it "should not allow new instance of base class" do
    assert_raises(ActiveRecord::StatementInvalid) do
      Character.new
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
      Character.find(character.id).should eq(character)
    end
  end

  describe "display_name" do
    it "should be the characters name" do
      character.display_name.should eq(character.name)
    end
  end

  describe "character_id" do
    it "should be the characters id" do
      character.character_id.should eq(character.id)
    end
  end

  describe "is_disabled?" do
    it "should return true when character is removed" do
      character.is_disabled?.should be_false
      character.destroy
      character.is_removed.should_not be_false
      Character.find(character).is_disabled?.should be_true
    end

    it "should return true when character's owner is disabled" do
      character.user_profile.user.disable_by_admin
      character.user_profile.is_disabled?.should be_true
      character.is_removed.should be_false
      character.is_disabled?.should be_true
    end

    it "should return false when not removed and owner is active" do
      character.user_profile.is_disabled?.should be_false
      character.is_removed.should be_false
      character.is_disabled?.should be_false
    end
  end

  describe "destroy" do
    it "should mark character as is_removed" do
      character.should be_valid
      character.destroy.should be_true
      character.reload.is_removed.should be_true
    end

    it "should not delete character" do
      character.should be_valid
      character.destroy.should be_true
      Character.exists?(character).should be_true
    end
  end
end
