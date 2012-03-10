# == Schema Information
#
# Table name: user_profiles
#
#  id                :integer         not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  avatar            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean         default(TRUE)
#  title             :string(255)
#  location          :string(255)
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

  it "should not require a location" do
    Factory.build(:user_profile, :location => nil).should be_valid
  end
  it "should not require a limit location to 30 characters" do
    Factory.build(:user_profile, :location => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").should be_valid
    Factory.build(:user_profile, :location => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").should_not be_valid
  end

  it "should not  require a last name" do
    Factory.build(:user_profile, :last_name => nil).should be_valid
  end

  it "should require a display name" do
    Factory.build(:user_profile, :display_name => nil).should_not be_valid
  end

  it "should ensure display names are not unique" do
    Factory.build(:user_profile, :display_name => profile.display_name).should be_valid
  end
  
  it "display name should reject company and administration restricted values" do
    excluded_names = %w{ crumblin Crumblin admin da }
    excluded_names.each do |name|
      build(:user_profile, :display_name => name).should_not be_valid
    end
  end
  
  it "display name should not reject domain restricted values" do
    ok_names = %w{ www wwW wWw wWW Www WwW WWw WWW m blog mobile }
    ok_names.each do |name|
      build(:user_profile, :display_name => name).should be_valid
    end
  end

  it "should set publicly viewable to true by default" do
    Factory.build(:user_profile).publicly_viewable.should be_true
  end
  
  it "should create an activity when created" do
    user_profile = create(:user_profile)
    
    activity = Activity.last
    activity.target.should eql user_profile
    activity.action.should eql 'joined'
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
  
  it "should respond to sent_messages" do
    profile.should respond_to(:sent_messages)
  end
  
  it "should respond to received_messages" do
    profile.should respond_to(:received_messages)
  end
  
  it "should respond to folders" do
    profile.should respond_to(:folders)
  end
  
  it "should respond to inbox" do
    profile.should respond_to(:inbox)
  end
  
  it "should respond to trash" do
    profile.should respond_to(:trash)
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
  
  describe "address_book" do
    it "should return the user profiles of all users in the same communities" do
      profile
      new_profile = DefaultObjects.user_profile
      new_profile.address_book.count.should eq(2)
      new_profile.address_book.should include(DefaultObjects.community_admin.user_profile)
      new_profile.address_book.should include(DefaultObjects.community_two.admin_profile)
    end
    
    it "should be empty if the user is in no communities" do
      profile.address_book.should be_empty
    end
    
    it "should not contain the users user profile" do
      new_profile = DefaultObjects.user_profile
      new_profile.address_book.count.should eq(2)
      new_profile.address_book.should_not include(profile)
    end
    
    it "should not contain duplicate user profiles" do
      profile
      profile_one = DefaultObjects.user_profile
      profile_two = DefaultObjects.additional_community_user_profile
      profile_one.is_member?(DefaultObjects.community)
      profile_one.is_member?(DefaultObjects.community_two)
      profile_two.is_member?(DefaultObjects.community)
      profile_two.is_member?(DefaultObjects.community_two)
      profile_one.address_book.count.should eq(3)
      profile_one.address_book.should include(profile_two)
    end
  end
  
  describe "sent_messages" do
    it "should return all the users sent messages" do
      message = create(:message)
      new_profile = DefaultObjects.user_profile
      message.author.should eq(new_profile)
      new_profile.sent_messages.count.should eq(1)
      new_profile.sent_messages.first.should eq(message)
    end

    it "should be empty if the user has no sent messages" do
      profile.sent_messages.should be_empty
    end
  end
  
  describe "received_messages" do
    it "should return all the users received messages" do
      new_profile = DefaultObjects.additional_community_user_profile
      startCount = new_profile.received_messages.count
      message = create(:message)
      message.recipients.first.should eq(new_profile)
      new_profile.received_messages.count.should eq(startCount + 1)
    end
    
    it "should return messages marked as is_removed" do
      new_profile = DefaultObjects.additional_community_user_profile
      startCount = new_profile.received_messages.count
      create(:message)
      message = create(:message).message_associations.first
      message.is_removed = true
      message.save.should be_true
      new_profile.received_messages.count.should eq(startCount + 2)
      new_profile.received_messages.find(message).is_removed.should be_true
    end
  end
  
    
  describe "unread_messages" do
    it "should return all the users unread messages" do
      new_profile = DefaultObjects.additional_community_user_profile
      startCount = new_profile.unread_messages.count
      message = create(:message)
      message.recipients.first.should eq(new_profile)
      new_profile.unread_messages.count.should eq(startCount + 1)
    end
    
    it "should not return unread messages marked as is_removed" do
      new_profile = DefaultObjects.additional_community_user_profile
      startCount = new_profile.unread_messages.count
      message = create(:message)
      message.message_associations.first.update_attributes(:is_removed => true)
      MessageAssociation.find(message.message_associations.first).is_removed.should be_true
      message.recipients.first.should eq(new_profile)
      new_profile.unread_messages.count.should eq(startCount)
    end
  end
  
  describe "folders" do
    it "should return all the users folders" do
      profile.folders.count.should eq(2)
    end
    
    it "should contain the users inbox folder" do
      profile.folders.first.name.should eq("Inbox")
    end
    
    it "should contain the users trash folder" do
      profile.folders.last.name.should eq("Trash")
    end
  end
  
  describe "inbox" do
    it "should be created with user profile" do
      profile.inbox.should be_a(Folder)
    end  
  
    it "should return the users inbox folder" do
      profile.inbox.name.should eq("Inbox")
    end
  end
  
  describe "trash" do
    it "should be created with user profile" do
      profile.trash.should be_a(Folder)
    end
      
    it "should return the users trash folder" do
      profile.trash.name.should eq("Trash")
    end  
  end

  describe "available_character_proxies" do
    before(:each) do
      @community_profile = create(:community_profile_with_characters)
      @member_profile = @community_profile.user_profile
      @community = @community_profile.community
    end
    it "should return all approved character proxies for a community" do
      expected_proxies = @community_profile.approved_character_proxies
      not_expected_proxies = @community_profile.pending_character_proxies
      available_proxies = @member_profile.available_character_proxies(@community)
      expected_proxies.each do |proxy|
        available_proxies.include?(proxy).should be_true
      end
      not_expected_proxies.each do |proxy|
        available_proxies.include?(proxy).should be_false
      end
    end
    it "should return all approved character proxies for a community and game" do
      game = DefaultObjects.wow
      expected_proxies = @community_profile.approved_character_proxies.delete_if{ |proxy| proxy.game != game}
      not_expected_proxies = @community_profile.approved_character_proxies.delete_if{ |proxy| expected_proxies.include?(proxy) }
      available_proxies = @member_profile.available_character_proxies(@community, game)
      expected_proxies.each do |proxy|
        available_proxies.include?(proxy).should be_true
      end
      not_expected_proxies.each do |proxy|
        available_proxies.include?(proxy).should be_false
      end
    end
  end

  describe "read_announcements" do
    before(:each) do
      @profile_with_announcements = DefaultObjects.user_profile
      @profile_with_announcements.announcements.size.should be > 0
      @profile_with_announcements.unread_announcements.size.should >= 1
      @unread_announcement = @profile_with_announcements.unread_announcements.first
    end
    it "should only contain read announcements" do
      @profile_with_announcements.read_announcements.each do |announcement|
        @profile_with_announcements.has_seen?(announcement).should be_true
      end
      @profile_with_announcements.read_announcements.include?(@unread_announcement).should be_false
    end
    it "should automaticaly get updated when a user reads an announcement" do
      @unread_announcement.update_viewed(@profile_with_announcements)
      @profile_with_announcements.reload
      @profile_with_announcements.has_seen?(@unread_announcement).should be_true
      @profile_with_announcements.read_announcements.include?(@unread_announcement).should be_true
      @profile_with_announcements.unread_announcements.include?(@unread_announcement).should be_false
    end
  end

  describe "unread_announcements" do
    before(:each) do
      @profile_with_announcements = DefaultObjects.user_profile
      @profile_with_announcements.announcements.size.should be > 0
    end
    it "should only contain unread announcements" do
      @profile_with_announcements.unread_announcements.each do |announcement|
        @profile_with_announcements.has_seen?(announcement).should be_false
      end
    end
    it "should automaticaly get updated when an announcement is made" do
      unread_size = @profile_with_announcements.unread_announcements.size
      announcement = DefaultObjects.community.announcements.new(:name => "Announcement 2", 
        :body => "Herp Derp!")
      announcement.user_profile = DefaultObjects.community.admin_profile
      announcement.save!
      @profile_with_announcements = UserProfile.find(@profile_with_announcements)
      @profile_with_announcements.unread_announcements.size.should_not eq(unread_size)
    end
  end
  
  describe "remove_all_avatars" do
    it "should call remove_avatar! on self" do
      profile.should_receive(:remove_avatar!)
      profile.remove_all_avatars
    end
    
    it "should call remove_avatar! on all characters" do
      character = create(:wow_char_profile)
      profile = character.user_profile
      character = profile.characters.first
      character.should_receive(:remove_avatar!)
      profile.remove_all_avatars
    end
  end
  
  describe "destroy" do
    it "should delete user_profile" do
      profile.destroy
      UserProfile.exists?(profile).should be_false
    end
    
    it "should mark user_profile's owned_communities as deleted" do
      profile = DefaultObjects.community_admin.user_profile
      owned_communities = profile.owned_communities.all
      profile.destroy
      owned_communities.should_not be_empty
      owned_communities.each do |owned_community|
        Community.exists?(owned_community).should be_false
        Community.with_deleted.exists?(owned_community).should be_true
      end
    end
    
    it "should mark user_profile's community_profiles as deleted" do
      profile = DefaultObjects.user_profile
      community_profiles = profile.community_profiles.all
      profile.destroy
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
        CommunityProfile.with_deleted.exists?(community_profile).should be_true
      end
    end
    
    it "should mark user_profile's character_proxies as is_removed" do
      profile = create(:wow_char_profile).user_profile
      character_proxies = profile.character_proxies.all
      profile.destroy
      character_proxies.should_not be_empty
      character_proxies.each do |character_proxy|
        character_proxy.reload.is_removed.should be_true
      end
    end
    
    it "should mark user_profile's community_applications as deleted" do
      profile = DefaultObjects.user_profile
      community_applications = profile.community_applications.all
      profile.destroy
      community_applications.should_not be_empty
      community_applications.each do |community_application|
        CommunityApplication.exists?(community_application).should be_false
        CommunityApplication.with_deleted.exists?(community_application).should be_true
      end
    end
    
    it "should mark user_profile's view_logs as deleted" do
      profile = create(:view_log).user_profile
      view_logs = profile.view_logs.all
      profile.destroy
      view_logs.should_not be_empty
      view_logs.each do |view_log|
        ViewLog.exists?(view_log).should be_false
        ViewLog.with_deleted.exists?(view_log).should be_true
      end
    end
    
    it "should delete user_profile's sent_messages" do
      profile = create(:message).author
      sent_messages = profile.sent_messages.all
      profile.destroy
      sent_messages.should_not be_empty
      sent_messages.each do |message|
        Message.exists?(message).should be_false
      end
    end
    
    it "should delete user_profile's received_messages" do
      profile = create(:message).message_associations.first.recipient
      received_messages = profile.received_messages.all
      profile.destroy
      received_messages.should_not be_empty
      received_messages.each do |message|
        MessageAssociation.exists?(message).should be_false
      end
    end
    
    it "should delete user_profile's folders" do
      folders = profile.folders.all
      profile.destroy
      folders.should_not be_empty
      folders.each do |folder|
        Folder.exists?(folder).should be_false
      end
    end
    
    it "should mark user_profile's discussions as deleted" do
      profile = create(:discussion).user_profile
      discussions = profile.discussions.all
      profile.destroy
      discussions.should_not be_empty
      discussions.each do |discussion|
        Discussion.exists?(discussion).should be_false
        Discussion.with_deleted.exists?(discussion).should be_true
      end
    end
    
    it "should mark user_profile's comments as deleted" do
      profile = create(:comment).user_profile
      comments = profile.comments.all
      profile.destroy
      comments.should_not be_empty
      comments.each do |comment|
        Comment.exists?(comment).should be_false
        Comment.with_deleted.exists?(comment).should be_true
      end
    end
  end
  
  describe "nuke" do
    it "should delete user_profile's swtor_characters" do
      profile = create(:swtor_char_profile).user_profile
      swtor_characters = profile.swtor_characters.all
      profile.nuke
      swtor_characters.should_not be_empty
      swtor_characters.each do |swtor_character|
        SwtorCharacter.exists?(swtor_character).should be_false
      end
    end

    it "should delete user_profile's wow_characters" do
      profile = create(:wow_char_profile).user_profile
      wow_characters = profile.wow_characters.all
      profile.nuke
      wow_characters.should_not be_empty
      wow_characters.each do |wow_character|
        WowCharacter.exists?(wow_character).should be_false
      end
    end
    
    it "should delete user_profile's character_proxies" do
      profile = create(:wow_char_profile).user_profile
      character_proxies = profile.character_proxies.all
      profile.nuke
      character_proxies.should_not be_empty
      character_proxies.each do |character_proxy|
        CharacterProxy.exists?(character_proxy).should be_false
      end
    end
    
    it "should call nuke on user_profile's owned_communities" do
      profile = DefaultObjects.community_admin.user_profile
      owned_communities = profile.owned_communities.all
      profile.nuke
      owned_communities.should_not be_empty
      owned_communities.each do |owned_community|
        Community.exists?(owned_community).should be_false
        Community.with_deleted.exists?(owned_community).should be_false
      end
    end
    
    it "should delete user_profile's community_applications" do
      profile = DefaultObjects.user_profile
      community_applications = profile.community_applications.all
      profile.nuke
      community_applications.should_not be_empty
      community_applications.each do |community_application|
        CommunityApplication.exists?(community_application).should be_false
        CommunityApplication.with_deleted.exists?(community_application).should be_false
      end
    end
    
    it "should delete user_profile's community_profiles" do
      profile = DefaultObjects.user_profile
      community_profiles = profile.community_profiles.all
      profile.nuke
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
        CommunityProfile.with_deleted.exists?(community_profile).should be_false
      end
    end
    
    it "should delete user_profile's view_logs" do
      profile = create(:view_log).user_profile
      view_logs = profile.view_logs.all
      profile.nuke
      view_logs.should_not be_empty
      view_logs.each do |view_log|
        ViewLog.exists?(view_log).should be_false
        ViewLog.with_deleted.exists?(view_log).should be_false
      end
    end
    
    it "should delete user_profile's discussions" do
      profile = create(:discussion).user_profile
      discussions = profile.discussions.all
      profile.nuke
      discussions.should_not be_empty
      discussions.each do |discussion|
        Discussion.exists?(discussion).should be_false
        Discussion.with_deleted.exists?(discussion).should be_false
      end
    end
    
    it "should delete user_profile's comments" do
      profile = create(:comment).user_profile
      comments = profile.comments.all
      profile.nuke
      comments.should_not be_empty
      comments.each do |comment|
        Comment.exists?(comment).should be_false
        Comment.with_deleted.exists?(comment).should be_false
      end
    end
  end
end
