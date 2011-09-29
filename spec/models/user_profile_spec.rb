# == Schema Information
#
# Table name: user_profiles
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  first_name        :string(255)
#  last_name         :string(255)
#  avatar            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean         default(TRUE)
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
  it "should not require a first name" do
    Factory.build(:user_profile, :first_name => nil).should be_valid
  end

  it "should not  require a last name" do
    Factory.build(:user_profile, :last_name => nil).should be_valid
  end

  it "should require a display name" do
    Factory.build(:user_profile, :display_name => nil).should_not be_valid
  end

  it "should ensure display names are unique" do
    Factory.build(:user_profile, :display_name => profile.display_name).should_not be_valid
  end

  it "should set publicly viewable to true by default" do
    Factory.build(:user_profile).publicly_viewable.should be_true
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

  it "should respond to view_logs" do
    profile.should respond_to(:view_logs)
  end

###
# Instance Method Tests
###
  it "name should return a string of the user's display name" do
    billy = create(:billy)
    billy.user_profile.name.should eq(billy.user_profile.display_name)
  end

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

  describe "add_new_role method" do
    it "should add a valid role" do
      valid_roles = []
      admin = create(:community_admin)
      community = admin.user_profile.community_profiles.first.community
      original_role_size = admin.user_profile.roles.size
      valid_roles << create(:role, :community => community)
      valid_roles.each do |role|
        admin.user_profile.add_new_role(role).should be_true
      end
      admin = User.find(admin)
      admin.user_profile.roles.size.should eq((original_role_size+valid_roles.size))
    end

    it "should not add an invalid role" do
      invalid_roles = []
      admin = create(:community_admin)
      community = admin.user_profile.community_profiles.first.community
      original_role_size = admin.user_profile.roles.size
      invalid_roles << create(:role, :community => create(:community))
      invalid_roles.each do |role|
        admin.user_profile.add_new_role(role).should be_false
      end
      admin = User.find(admin)
      admin.user_profile.roles.size.should eq((original_role_size))
    end
  end

  describe "roles" do
    it "should return all of the roles that a user_profile has from all community profiles" do
      billy = create(:billy)
      all_roles = Array.new
      billy.user_profile.community_profiles.each do |community_profile|
        all_roles.concat(community_profile.roles)
      end
      billy.user_profile.roles.should eq(all_roles)
    end
  end
end
