# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe UserProfile do
  let(:profile) { Factory.create(:user_profile) }

  it "should create a new instance given valid attributes" do
    profile.should be_valid
  end

###
# Attribute Tests
###
  it "should require a first name" do
    Factory.build(:user_profile, :first_name => nil).should_not be_valid
  end

  it "should require a last name" do
    Factory.build(:user_profile, :last_name => nil).should_not be_valid
  end

  it "should require a user" do
    Factory.build(:user_profile, :user => nil).should_not be_valid
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
        Factory.build(:user_profile, :avatar => File.open("#{Rails.root}/spec/testing_files/#{filename}")).should_not be_valid
      end
    end
  end

###
# Instance Method Tests
###
  it "characters should return all characters" do
    billy = create(:billy)
    billy.user_profile.should_not be_nil
    total = CharacterProxy.all_characters.count
    billy.user_profile.characters.count.should eq(total)
  end

  describe "character_proxies_for_a_game" do
    it "should return all character proxies for the game" do
      billy = create(:billy)
      proxies = billy.user_profile.character_proxies
      total_wow = 0
      proxies.each do |proxy|
        total_wow += 1 if proxy.game == DefaultObjects.wow
      end
      billy.user_profile.character_proxies_for_a_game(DefaultObjects.wow).count.should eq(total_wow)
    end

    it "should only return character proxies for the game" do
      billy = create(:billy)
      all_wow_characters = billy.user_profile.character_proxies_for_a_game(DefaultObjects.wow)
      all_wow_characters.each do |character|
        character.game.should eq(DefaultObjects.wow)
      end
    end
  end

  describe "default_character_proxy_for_a_game" do
    it "should return the default if there is one of the game" do
      profile = create(:user_profile)
      proxy = create(:character_proxy, :user_profile => profile)
      proxy.default_character.should be_true
      profile.default_character_proxy_for_a_game(DefaultObjects.wow).should eq(proxy)
    end

    it "should return nil if there is not one of the game" do
      profile = create(:user_profile)
      create(:character_proxy, :user_profile => profile)
      profile.default_character_proxy_for_a_game(DefaultObjects.swtor).should be_nil
    end
  end
end
