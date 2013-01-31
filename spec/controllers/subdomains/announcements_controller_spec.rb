require 'spec_helper'

describe Subdomains::AnnouncementsController do
  let(:community) { create(:community_with_community_games) }
  let(:admin) { community.admin_profile.user }
  let(:member) { create(:user_profile_with_characters).user }
  let(:non_member) { create(:user_profile).user }
  let(:announcement) { create(:announcement, :community => community, :user_profile => admin.user_profile) }
  let(:announcement_attr) { attributes_for(:announcement, :community => community, :user_profile => admin.user_profile) }
  let(:invalid_announcement_attr) { attributes_for(:announcement, :community => community, :name => nil) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
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
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => announcement
      response.should be_forbidden
    end
  end

  describe "GET new" do
    it "assigns a new announcement as @announcement when authenticated as a admin" do
      sign_in admin
      get :new
      assigns(:announcement).should be_a_new(Announcement)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :new
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :new
      response.should be_forbidden
    end

    it "should respond forbidden when a member without permissions" do
      sign_in member
      get :new
      response.should be_forbidden
    end
  end

  describe "POST create when authenticated as admin" do
    before(:each) {
      sign_in admin
    }

    describe "with valid params" do
      it "creates a new Announcement" do
        expect {
          post :create, :announcement => announcement_attr
        }.to change(Announcement, :count).by(1)
      end

      it "assigns a newly created announcement as @announcement" do
        post :create, :announcement => announcement_attr
        assigns(:announcement).should be_a(Announcement)
        assigns(:announcement).should be_persisted
      end

      it "redirects to the created announcement" do
        post :create, :announcement => announcement_attr
        some_announcement = Announcement.unscoped.last
        response.should redirect_to(announcement_url(some_announcement))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved announcement as @announcement" do
        post :create, :announcement => invalid_announcement_attr
        assigns(:announcement).should be_a_new(Announcement)
      end

      it "re-renders the 'new' template" do
        post :create, :announcement => invalid_announcement_attr
        response.should render_template("new")
      end
    end
  end

  describe "POST create" do
    it "should redirect to new user session path when not authenticated as a user" do
      post :create, :announcement => announcement_attr
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :announcement => announcement_attr
      response.should be_forbidden
    end

    it "should respond forbidden when user is member" do
      sign_in member
      post :create, :announcement => announcement_attr
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested discussion when authenticated as admin" do
      announcement
      sign_in admin
      expect {
        delete :destroy, :id => announcement
      }.to change(Announcement, :count).by(-1)
    end

    it "redirects to the announcements list when authenticated as admin" do
      announcement
      sign_in admin
      delete :destroy, :id => announcement
      response.should redirect_to(announcements_url)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      announcement
      delete :destroy, :id => announcement
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      announcement
      sign_in non_member
      delete :destroy, :id => announcement
      response.should be_forbidden
    end

    it "should respond forbidden when a member but not admin" do
      announcement
      sign_in member
      delete :destroy, :id => announcement
      response.should be_forbidden
    end
  end

  describe "POST lock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
    }

    it "should lock the announcement when authenticated as community admin" do
      sign_in admin
      post :lock, :id => announcement
      Announcement.find(announcement).is_locked.should be_true
    end

    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :lock, :id => announcement
      response.should redirect_to("/")
    end

    it "should not lock the announcement when authenticated as a member" do
      sign_in member
      post :lock, :id => announcement
      Announcement.find(announcement).is_locked.should be_false
    end

    it "should not lock the announcement when not authenticated as a user" do
      post :lock, :id => announcement
      Announcement.find(announcement).is_locked.should be_false
    end

    it "should redirect to new user session path when not authenticated as a user" do
      post :lock, :id => announcement
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :lock, :id => announcement
      response.should be_forbidden
    end
  end

  describe "POST unlock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
      announcement.is_locked = true
      announcement.save!
    }

    it "should unlock the announcement when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => announcement
      Announcement.find(announcement).is_locked.should be_false
    end

    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => announcement
      response.should redirect_to("/")
    end

    it "should not unlock the announcement when authenticated as a member" do
      sign_in member
      post :unlock, :id => announcement
      Announcement.find(announcement).is_locked.should be_true
    end

    it "should not unlock the announcement when not authenticated as a user" do
      post :unlock, :id => announcement
      Announcement.find(announcement).is_locked.should be_true
    end

    it "should redirect to new user session path when not authenticated as a user" do
      post :unlock, :id => announcement
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :unlock, :id => announcement
      response.should be_forbidden
    end
  end

  describe "DELETE batch_destroy" do
    before(:each) do
      community
      admin
      announcement
    end

    it "should be forbidden when authenticated as a non member" do
      sign_in non_member
      post 'batch_destroy', :ids => [announcement.id => 'true']
      response.should be_forbidden
    end

    it "should be forbidden when authenticated as a member" do
      sign_in member
      post 'batch_destroy', :ids => [announcement.id => 'true']
      response.should be_forbidden
    end

    it "should redirect to user sign_in when not authenticated as a user" do
      post 'batch_destroy', :ids => [announcement.id => 'true']
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end
end