# == Schema Information
#
# Table name: communities
#
#  id                              :integer         not null, primary key
#  name                            :string(255)
#  slogan                          :string(255)
#  is_accepting_members            :boolean         default(TRUE)
#  email_notice_on_application     :boolean         default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime        not null
#  updated_at                      :datetime        not null
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  is_protected_roster             :boolean         default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#  is_public_roster                :boolean         default(TRUE)
#  deleted_at                      :datetime
#  background_image                :string(255)
#  background_color                :string(255)
#  theme_id                        :integer
#  title_color                     :string(255)
#  home_page_id                    :integer
#  pending_removal                 :boolean         default(FALSE)
#  action_items                    :text
#  pitch                           :text
#

require 'spec_helper'

describe Community do
  let(:community) { create(:community) }

  it "should create a new instance given valid attributes" do
    community.should be_valid
  end

  describe "after creation" do
    it "should have a default member role" do
      community2 = build(:community, :member_role => nil)
      community2.save.should be_true
      community2.member_role.should_not be_nil
    end
    it "should have a default application form" do
      community2 = build(:community, :community_application_form => nil)
      community2.save.should be_true
      community2.member_role.should_not be_nil
    end
    it "should have a default theme" do
      community2 = build(:community, :theme => nil)
      community2.save.should be_true
      community2.member_role.should_not be_nil
    end
  end

  describe "background_color" do
    it "should allow blank" do
      build(:community, :background_color => "").should be_valid
    end
    it "should accept valid format" do
      valid_names = %w{ 111111 000000 1AA1AA FFFFFF } # TESTING Valid community names for testing.
      valid_names.each do |name|
        build(:community, :background_color => name).should be_valid
      end
    end

    it "should reject invalid format" do
      invalid_names = %w{ #111111111 #111111 aBcDEFD } # TESTING Invalid community names for testing.
      invalid_names.each do |name|
        build(:community, :background_color => name).should_not be_valid
      end
    end
  end

  describe "title_color" do
    it "should allow blank" do
      build(:community, :title_color => "").should be_valid
    end
    it "should accept valid format" do
      valid_names = %w{ 111111 000000 1AA1AA FFFFFF } # TESTING Valid community names for testing.
      valid_names.each do |name|
        build(:community, :title_color => name).should be_valid
      end
    end

    it "should reject invalid format" do
      invalid_names = %w{ #111111111 #111111 aBcDEFD } # TESTING Invalid community names for testing.
      invalid_names.each do |name|
        build(:community, :title_color => name).should_not be_valid
      end
    end
  end

  describe "name" do
    it "should be required" do
      build(:community, :name => nil).should_not be_valid
    end

    it "should be unique" do
      build(:community, :name => community.name).should_not be_valid
    end

    it "should accept valid format" do
      valid_names = %w{ OMGLOLOLOLOL My\ Community My-Community Community1 } # TESTING Valid community names for testing.
      valid_names.each do |name|
        build(:community, :name => name).should be_valid
      end
    end

    it "should reject invalid format" do
      invalid_names = %w{ 1212312&^*&^ #1Community My\ #1\ Community @TopComm } # TESTING Invalid community names for testing.
      invalid_names.each do |name|
        build(:community, :name => name).should_not be_valid
      end
    end

    it "should reject all restricted values" do
      excluded_names = %w{ www WWW wWw w\ w\ w crumblin Crumblin admin blog }
      excluded_names.each do |name|
        build(:community, :name => name).should_not be_valid
      end
    end

    it "should not be editable" do
      old_name = community.name
      community.update_attributes(:name => "ChangedName")
      community.name.should == old_name
    end
  end

  describe "slogan" do
    it "should be optional" do
      build(:community, :slogan => nil).should be_valid
    end
  end

  describe "pitch" do
    it "should be optional" do
      build(:community, :pitch => nil).should be_valid
    end
    it "should be under 100 characters" do
      build(:community, :pitch => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").should be_valid
      build(:community, :pitch => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").should_not be_valid
    end
  end

  describe "subdomain" do
    it "should be created on save" do
      good_name_subdomain_hash = Hash[ "ALLUPPERCASENAME", "alluppercasename", "with space", "withspace", "with-dash", "withdash", "withnumber1", 'withnumber1'] # TESTING Valid community subdomain hash

      good_name_subdomain_hash.each do |name, subdomain|
        create(:community, :name => name).subdomain.should eq(subdomain)
      end
    end

    it "should be unique" do
      good_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "MyCommunity", "My-Community", "Community1"] # TESTING Valid community pairs
      bad_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "omglolololol", "My-Community", "My Community"] # TESTING Invalid community pairs

      good_name_pairs_hash.each  do |firstName, secondName|
        c = create(:community, :name => firstName)
        c.should be_valid
        build(:community, :name => secondName).should be_valid
        c.delete.should be_valid
      end

      bad_name_pairs_hash.each  do |firstName, secondName|
        c = create(:community, :name => firstName)
        c.should be_valid
        build(:community, :name => secondName).should_not be_valid
        c.delete.should be_valid
      end
    end
  end

  describe "is_protected_roster" do
    let(:community_profile) { create(:community_profile_with_characters, :community => create(:community_with_supported_games)) }
    let(:new_proxy) { create(:character_proxy_with_wow_character, :user_profile => community_profile.user_profile)}

    it "should be false by default" do
      community.is_protected_roster.should be_false
    end

    describe "when true" do
      it "should make roster changes pending" do
        community_profile.community.update_attribute(:is_protected_roster, true)        
        ra = community_profile.roster_assignments.create!(:character_proxy => new_proxy, :is_pending => false, :supported_game => community_profile.community.supported_games.where(:game_type => "Wow").first )
        ra.is_pending.should be_true
      end
    end

    describe "when false" do
      it "should not make roster changes pending" do
        community_profile.community.update_attribute(:is_protected_roster, true)
        ra = community_profile.roster_assignments.create!(:character_proxy => new_proxy, :is_pending => true, :supported_game => community_profile.community.supported_games.where(:game_type => "Wow").first )
        ra.community_profile.community.is_protected_roster.should be_true
        RosterAssignment.find_by_id(ra.id).is_pending.should be_true
      end
    end
  end

  describe "get_current_community_roster" do
    let(:wow) { DefaultObjects.wow }
    let(:community_profile) { create(:community_profile_with_characters) }
    let(:community_profile2) { create(:community_profile_with_characters, :community => community_profile.community )}
    let(:community) { community_profile2.community }

    it "should return all rostered characters when game is nil" do
      expected_size = community_profile.approved_character_proxies.size + community_profile2.approved_character_proxies.size
      community_roster = community.get_current_community_roster
      community_profile.approved_character_proxies.each do |proxy|
        community_roster.include?(proxy).should be_true
      end
      community_profile.pending_character_proxies.each do |proxy|
        community_roster.include?(proxy).should be_false
      end
      community_profile2.approved_character_proxies.each do |proxy|
        community_roster.include?(proxy).should be_true
      end
      community_profile2.pending_character_proxies.each do |proxy|
        community_roster.include?(proxy).should be_false
      end
      community_roster.size.should eq(expected_size)
    end

    it "should return only rostered characters that match game when game is specified" do
      expected_size = community_profile.approved_character_proxies.delete_if{|proxy| proxy.game != wow}.size + community_profile2.approved_character_proxies.delete_if{|proxy| proxy.game != wow}.size
      community_roster = community.get_current_community_roster(wow)
      community_profile.approved_character_proxies.delete_if{|proxy| proxy.game != wow}.each do |proxy|
        community_roster.include?(proxy).should be_true
      end
      community_profile.pending_character_proxies.delete_if{|proxy| proxy.game != wow}.each do |proxy|
        community_roster.include?(proxy).should be_false
      end
      community_profile2.approved_character_proxies.delete_if{|proxy| proxy.game != wow}.each do |proxy|
        community_roster.include?(proxy).should be_true
      end
      community_profile2.pending_character_proxies.delete_if{|proxy| proxy.game != wow}.each do |proxy|
        community_roster.include?(proxy).should be_false
      end
      community_roster.size.should eq(expected_size)
    end
  end

  it "should be accepting members by default" do
    community.is_accepting_members.should be_true
  end

  it "should email on application by default" do
    community.email_notice_on_application.should be_true
  end
  
  describe "destroy" do
    it "should mark community as deleted" do
      community.destroy
      Community.exists?(community).should be_false
      Community.with_deleted.exists?(community).should be_true
    end
    
    it "should mark community's community_application_form as deleted" do
      community_application_form = community.community_application_form
      community.destroy
      community_application_form.should be_a(CustomForm)
      CustomForm.exists?(community_application_form).should be_false
      CustomForm.with_deleted.exists?(community_application_form).should be_true
    end
    
    it "should mark community's community_applications as deleted" do
      community = create(:community_application).community
      community_applications = community.community_applications.all
      community.destroy
      community_applications.should_not be_empty
      community_applications.each do |community_application|
        CommunityApplication.exists?(community_application).should be_false
        CommunityApplication.with_deleted.exists?(community_application).should be_true
      end
    end
    
    it "should mark community's roles as deleted" do
      community = create(:role).community
      roles = community.roles.all
      community.destroy
      roles.should_not be_empty
      roles.each do |role|
        Role.exists?(role).should be_false
        Role.with_deleted.exists?(role).should be_true
      end
    end
    
    it "should mark community's member_role as deleted" do
      member_role = community.member_role
      community.destroy
      member_role.should be_a(Role)
      Role.exists?(member_role).should be_false
      Role.with_deleted.exists?(member_role).should be_true
    end
    
    it "should mark community's supported_games as deleted" do
      community = create(:wow_supported_game).community
      supported_games = community.supported_games.all
      community.destroy
      supported_games.should_not be_empty
      supported_games.each do |supported_game|
        SupportedGame.exists?(supported_game).should be_false
        SupportedGame.with_deleted.exists?(supported_game).should be_true
      end
    end
    
    it "should mark community's custom_forms as deleted" do
      community = create(:custom_form).community
      custom_forms = community.custom_forms.all
      community.destroy
      custom_forms.should_not be_empty
      custom_forms.each do |custom_form|
        CustomForm.exists?(custom_form).should be_false
        CustomForm.with_deleted.exists?(custom_form).should be_true
      end
    end
    
    it "should mark community's community_profiles as deleted" do
      community = create(:community_profile).community
      community_profiles = community.community_profiles.all
      community.destroy
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
        CommunityProfile.with_deleted.exists?(community_profile).should be_true
      end
    end
    
    it "should mark community's discussion_spaces as deleted" do
      community = create(:discussion_space).community
      discussion_spaces = community.discussion_spaces.all
      community.destroy
      discussion_spaces.should_not be_empty
      discussion_spaces.each do |discussion_space|
        DiscussionSpace.exists?(discussion_space).should be_false
        DiscussionSpace.with_deleted.exists?(discussion_space).should be_true
      end
    end
    
    it "should mark community's page_spaces as deleted" do
      community = create(:page_space).community
      page_spaces = community.page_spaces.all
      community.destroy
      page_spaces.should_not be_empty
      page_spaces.each do |page_space|
        PageSpace.exists?(page_space).should be_false
        PageSpace.with_deleted.exists?(page_space).should be_true
      end
    end
  end
  
  describe "nuke" do    
    it "should delete community" do
      community.nuke
      Community.exists?(community).should be_false
      Community.with_deleted.exists?(community).should be_false
    end
    
    it "should delete community applications comments" do
      community_application = create(:community_application)
      create(:comment, :commentable_id => community_application.id, :commentable_type => community_application.class.name)
      community = community_application.community
      community_application_comments = community_application.comments.all
      community.nuke
      community_application_comments.should_not be_empty
      community_application_comments.each do |community_application_comment|
        Comment.exists?(community_application_comment).should be_false
        Comment.with_deleted.exists?(community_application_comment).should be_false
      end
    end
    
    it "should delete community's discussions" do
      discussion_space = create(:discussion).discussion_space
      community = discussion_space.community
      discussions = discussion_space.discussions.all
      community.nuke
      discussions.should_not be_empty
      discussions.each do |discussion|
        Discussion.exists?(discussion).should be_false
        Discussion.with_deleted.exists?(discussion).should be_false
      end
    end
    
    it "should delete community's community_application_form" do
      community_application_form = community.community_application_form
      community.nuke
      community_application_form.should be_a(CustomForm)
      CustomForm.exists?(community_application_form).should be_false
      CustomForm.with_deleted.exists?(community_application_form).should be_false
    end
    
    it "should delete community's community_applications" do
      community = create(:community_application).community
      community_applications = community.community_applications.all
      community.nuke
      community_applications.should_not be_empty
      community_applications.each do |community_application|
        CommunityApplication.exists?(community_application).should be_false
        CommunityApplication.with_deleted.exists?(community_application).should be_false
      end
    end
    
    it "should delete community's roles" do
      community = create(:role).community
      roles = community.roles.all
      community.nuke
      roles.should_not be_empty
      roles.each do |role|
        Role.exists?(role).should be_false
        Role.with_deleted.exists?(role).should be_false
      end
    end
    
    it "should delete community's member_role" do
      member_role = community.member_role
      community.nuke
      member_role.should be_a(Role)
      Role.exists?(member_role).should be_false
      Role.with_deleted.exists?(member_role).should be_false
    end
    
    it "should delete community's supported_games" do
      community = create(:wow_supported_game).community
      supported_games = community.supported_games.all
      community.nuke
      supported_games.should_not be_empty
      supported_games.each do |supported_game|
        SupportedGame.exists?(supported_game).should be_false
        SupportedGame.with_deleted.exists?(supported_game).should be_false
      end
    end
    
    it "should delete community's custom_forms" do
      community = create(:custom_form).community
      custom_forms = community.custom_forms.all
      community.nuke
      custom_forms.should_not be_empty
      custom_forms.each do |custom_form|
        CustomForm.exists?(custom_form).should be_false
        CustomForm.with_deleted.exists?(custom_form).should be_false
      end
    end
    
    it "should delete community's community_profiles" do
      community = create(:community_profile).community
      community_profiles = community.community_profiles.all
      community.nuke
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
        CommunityProfile.with_deleted.exists?(community_profile).should be_false
      end
    end
    
    it "should delete community's discussion_spaces" do
      community = create(:discussion_space).community
      discussion_spaces = community.discussion_spaces.all
      community.nuke
      discussion_spaces.should_not be_empty
      discussion_spaces.each do |discussion_space|
        DiscussionSpace.exists?(discussion_space).should be_false
        DiscussionSpace.with_deleted.exists?(discussion_space).should be_false
      end
    end
    
    it "should delete community's page_spaces" do
      community = create(:page_space).community
      page_spaces = community.page_spaces.all
      community.nuke
      page_spaces.should_not be_empty
      page_spaces.each do |page_space|
        PageSpace.exists?(page_space).should be_false
        PageSpace.with_deleted.exists?(page_space).should be_false
      end
    end
  end

  describe "home_page" do
    it "should allow blank" do
      community.home_page_id = ''
      community.should be_valid
    end

    it "should allow a page that belongs to the community" do
      page_space = create(:page_space, :community_id => community.id)
      page = create(:page, :page_space_id => page_space.id)
      community.home_page_id = page.id
      community.should be_valid
    end

    it "should not allow a page that belongs to another community" do
      other_community = create(:community)
      page_space = create(:page_space, :community_id => other_community.id)
      page = create(:page, :page_space_id => page_space.id)
      community.home_page_id = page.id
      community.should_not be_valid
    end
  end
  
  it "should limit the number of communities a user can own during creation of community" do
    community = create(:community)
    admin_profile = community.admin_profile
    create_list(:community, 2, :admin_profile => admin_profile)
    admin_profile.reload.owned_communities.size.should eq 3
    build(:community, :admin_profile => admin_profile).should_not be_valid
  end
  
  it "should limit the number of communities a user can own during change of community admin" do
    pending "Waiting on the admin change feature."
    community2 = create(:community)
    admin_profile = community.admin_profile
    create_list(:community, 2, :admin_profile => admin_profile)
    admin_profile.reload.owned_communities.size.should eq 3
    community2 = create(:community)
    community2.admin_profile = admin_profile
    community2.save.should be_false
  end
end

