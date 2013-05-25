require 'spec_helper'

describe AnnouncementsController do
  let(:community) { create(:community_with_community_games) }
  let(:admin) { community.admin_profile.user }
  let(:member) { create(:user_profile_with_characters).user }
  let(:non_member) { create(:user_profile).user }
  let(:announcement) { create(:announcement, :community => community, :user_profile => admin.user_profile) }
  let(:announcement_attr) { attributes_for(:announcement, :community => community, :user_profile => admin.user_profile) }
  let(:invalid_announcement_attr) { attributes_for(:announcement, :community => community, :name => nil) }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  before(:each) do
    if not member.is_member?(community)
      application = FactoryGirl.create(:community_application,
          :community => community,
          :user_profile => member.user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => community.community_application_form, :user_profile => member.user_profile),
          :characters => member.user_profile.characters
        )
      mapping = Hash.new
      application.characters.each do |character|
        cg = community.community_games.where(:game_id => character.game.id).first
        mapping[character.id.to_s] = cg.id.to_s if cg
      end
      application.accept_application(community.admin_profile, mapping)
    end
  end

  describe "GET show" do
    it "assigns the requested announcement as @announcement when authenticated as a member" do
      sign_in admin
      get :show, :id => announcement
      assigns(:announcement).should eq(announcement)
    end

    it "assigns the requested announcement as @announcement when authenticated as a member" do
      sign_in member
      get :show, :id => announcement
      assigns(:announcement).should eq(announcement)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => announcement
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => announcement
      response.should be_forbidden
    end
  end

  describe "PUT batch_mark_as_seen" do
    before(:each) do
      community
      admin
      announcement
    end

    it "shouldn't be successful when authenticated as a non member" do
      sign_in non_member
      put 'batch_mark_as_seen', :ids => [announcement.id]
      non_member.read_announcements.include?(announcement).should be_false
    end

    it "should be successful when authenticated as a member" do
      sign_in admin
      put 'batch_mark_as_seen', :ids => [announcement.id]
      admin.read_announcements.include?(announcement).should be_true
    end

    it "should redirect to user sign_in when not authenticated as a user" do
      put 'batch_mark_as_seen', :ids => [announcement.id]
      response.should redirect_to(new_user_session_url)
    end
  end
end