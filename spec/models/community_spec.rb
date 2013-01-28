# == Schema Information
#
# Table name: communities
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  slogan                          :string(255)
#  is_accepting_members            :boolean          default(TRUE)
#  email_notice_on_application     :boolean          default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  is_protected_roster             :boolean          default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#  is_public_roster                :boolean          default(TRUE)
#  deleted_at                      :datetime
#  background_image                :string(255)
#  background_color                :string(255)
#  theme_id                        :integer
#  title_color                     :string(255)
#  home_page_id                    :integer
#  pending_removal                 :boolean          default(FALSE)
#  action_items                    :text
#  community_plan_id               :integer
#  community_profiles_count        :integer          default(0)
#

require 'spec_helper'

describe Community do
  let(:community) { create(:community) }
  let(:pro_community) { create(:pro_community) }
  let(:pro_community_with_user_upgrade) { create(:pro_community_with_user_upgrade) }

  it "should create a new instance given valid attributes" do
    community.should be_valid
    pro_community.should be_valid
    pro_community_with_user_upgrade.should be_valid
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
    it "should be pro" do
      pro_community.is_paid_community?.should be_true
    end
    it "should have upgrade" do
      pro_community_with_user_upgrade.max_number_of_users.should eq 120
    end
    it "should be free" do
      community.is_paid_community?.should be_false
    end
  end

  describe "max number of users" do
    def add_a_user(some_community)
      user_profile = create(:user_profile)
      app = some_community.community_applications.new
      app.prep(user_profile, some_community.community_application_form)
      user_profile.characters.each do |character|
        app.characters << cp if character.compatable_with_community?(some_community)
      end
      app.save!
      app.submission.custom_form.questions.each do |q|
        if q.is_required
          if Question::VALID_STYLES_WITHOUT_PA.include?(q.style)
            app.submission.answers.create!(question_id: q.id, body: 'Because you guys are awesome, and I want to be awesome too!', question_body: q.body)
          else
            app.submission.answers.create!(question_id: q.id, body: q.predefined_answers.first.body, question_body: q.body)
          end
        end
      end
      return app
    end
    it "should allow up to max number of users" do
      while community.community_profiles.count < community.max_number_of_users do
        add_a_user(community).accept_application(community.admin_profile).should eq true
      end
      add_a_user(community).accept_application(community.admin_profile).should eq false
    end
    it "should be 20 for free" do
      while community.community_profiles.count < 20 do
        add_a_user(community).accept_application(community.admin_profile).should eq true
      end
      add_a_user(community).accept_application(community.admin_profile).should eq false
    end
    it "should be up to custom plan amount" do
      while pro_community.community_profiles.count < 100 do
        add_a_user(pro_community).accept_application(community.admin_profile).should eq true
      end
      add_a_user(pro_community).accept_application(community.admin_profile).should eq false
    end
    it "should be up to custom plan with packs amount" do
      while pro_community_with_user_upgrade.community_profiles.count < 120 do
        add_a_user(pro_community_with_user_upgrade).accept_application(community.admin_profile).should eq true
      end
      add_a_user(pro_community_with_user_upgrade).accept_application(community.admin_profile).should eq false
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
      excluded_names = %w{ www WWW wWw w\ w\ w tabard.co Tabard.co Tabard tabard admin blog }
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

  describe "subdomain" do
    it "should be created on save" do
      good_name_subdomain_hash = Hash[ "ALLUPPERCASENAME", "alluppercasename", "with space", "withspace", "with-dash", "withdash"] # TESTING Valid community subdomain hash

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
    let(:community_profile) { create(:community_profile_with_characters, :community => create(:community_with_community_games)) }
    let(:new_character) { create(:wow_character, :user_profile => community_profile.user_profile)}

    it "should be false by default" do
      community.is_protected_roster.should be_false
    end

    describe "when true" do
      it "should make roster changes pending" do
        community_profile.community.update_column(:is_protected_roster, true)
        ra = community_profile.roster_assignments.create!(:character => new_character, :is_pending => false, :community_game => community_profile.community.community_games.where(:game_id => DefaultObjects.wow).first )
        ra.is_pending.should be_true
      end
    end

    describe "when false" do
      it "should not make roster changes pending" do
        community_profile.community.update_column(:is_protected_roster, true)
        ra = community_profile.roster_assignments.create!(:character => new_character, :is_pending => true, :community_game => community_profile.community.community_games.where(:game_id => DefaultObjects.wow).first )
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
      expected_size = community_profile.approved_characters.size + community_profile2.approved_characters.size
      community_roster = community.get_current_community_roster
      community_profile.approved_characters.each do |character|
        community_roster.include?(character).should be_true
      end
      community_profile.pending_characters.each do |character|
        community_roster.include?(character).should be_false
      end
      community_profile2.approved_characters.each do |character|
        community_roster.include?(character).should be_true
      end
      community_profile2.pending_characters.each do |character|
        community_roster.include?(character).should be_false
      end
      community_roster.size.should eq(expected_size)
    end

    it "should return only rostered characters that match game when game is specified" do
      expected_size = community_profile.approved_characters.delete_if{|character| character.game != wow}.size + community_profile2.approved_characters.delete_if{|character| character.game != wow}.size
      community_roster = community.get_current_community_roster(wow)
      community_profile.approved_characters.delete_if{|character| character.game != wow}.each do |character|
        community_roster.include?(character).should be_true
      end
      community_profile.pending_characters.delete_if{|character| character.game != wow}.each do |character|
        community_roster.include?(character).should be_false
      end
      community_profile2.approved_characters.delete_if{|character| character.game != wow}.each do |character|
        community_roster.include?(character).should be_true
      end
      community_profile2.pending_characters.delete_if{|character| character.game != wow}.each do |character|
        community_roster.include?(character).should be_false
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

    it "should mark community's community_games as deleted" do
      community = create(:wow_community_game).community
      community_games = community.community_games.all
      community.destroy
      community_games.should_not be_empty
      community_games.each do |community_game|
        CommunityGame.exists?(community_game).should be_false
        CommunityGame.with_deleted.exists?(community_game).should be_true
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

    it "should delete community's community_games" do
      community = create(:wow_community_game).community
      community_games = community.community_games.all
      community.nuke
      community_games.should_not be_empty
      community_games.each do |community_game|
        CommunityGame.exists?(community_game).should be_false
        CommunityGame.with_deleted.exists?(community_game).should be_false
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
    create_list(:community, 19, :admin_profile => admin_profile)
    admin_profile.reload.owned_communities.size.should eq 20
    build(:community, :admin_profile => admin_profile).should_not be_valid
  end

  it "should limit the number of communities a user can own during change of community admin" do
    pending "Waiting on the admin change feature."
    community2 = create(:community)
    admin_profile = community.admin_profile
    create_list(:community, 19, :admin_profile => admin_profile)
    admin_profile.reload.owned_communities.size.should eq 20
    community2 = create(:community)
    community2.admin_profile = admin_profile
    community2.save.should be_false
  end
end

