require 'spec_helper'

describe Subdomains::CommunitiesController do
  let(:billy) { create(:billy) }
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:community_att) { attributes_for(:community, :name => "TestName")}

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'disabled'" do
    it "should be success if community is disabled" do
      admin_user.mark_as_delinquent_account
      get 'disabled', id: community
      response.should be_success
    end
    it "should redirect to root if not disabled" do
      get 'disabled', id: community
      response.should redirect_to(root_url(subdomain: community.subdomain))
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'edit', :id => community
      response.response_code.should == 403
    end

    it "should be sucess when authenticated as the community admin user" do
      sign_in admin_user
      get 'edit', :id => community
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => community
      response.should redirect_to(new_user_session_url)
    end

    it "should render communities/edit template" do
      sign_in admin_user
      get 'edit', :id => community
      response.should render_template('communities/edit')
    end
  end

  describe "PUT 'update' when authenticated as a non admin user" do
    before(:each) do
      @new_slogan = 'My new slogan.'
      sign_in billy
      put 'update', :id => community, :community => { :slogan => @new_slogan }
    end

    it "should change attributes" do
      assigns[:community].slogan.should_not == @new_slogan
    end

    it "should respond with an error" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when authenticated as an admin user" do
    describe "with good data" do
      before(:each) do
        @new_slogan = 'My new slogan.'
        sign_in admin_user
        put 'update', :id => community, :community => { :slogan => @new_slogan }
      end

      it "should change attributes" do
        assigns[:community].slogan.should == @new_slogan
      end

      it "should redirect to the community edit view" do
        response.should redirect_to edit_community_settings_url
      end
    end
    describe "with bad data" do
      before(:each) do
        @invalid_title_color = "#111111111" # 51 length
        sign_in admin_user
        put 'update', :id => community, :community => { :title_color => @new_slogan }
      end

      it "should not change attributes" do
        assigns[:community].title_color.should_not == @invalid_title_color
      end

      it "should redirect to the community edit view" do
        response.should redirect_to edit_community_settings_url
      end
    end
    describe "with bad image" do
      before(:each) do
        @bad_background_image = File.open("#{Rails.root}/spec/testing_files/badAvatarFileType1.tiff") # Invalid file type
        sign_in admin_user
        put 'update', :id => community, :community => { :background_image => @bad_background_image }
      end

      it "should not change attributes" do
        assigns[:community].background_image.should_not == @bad_background_image
      end

      it "should redirect to the community edit view" do
        response.should redirect_to edit_community_settings_url
      end
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @slogan = "New Slogan"
      put 'update', :id => community, :community => { :slogan => @slogan }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url)
    end

    it "should not change attributes" do
      community.reload
      community.slogan.should_not eq @slogan
    end
  end
  describe "GET 'activites'" do
    describe "with good user" do
      it "should be success for community member" do
        sign_in admin_user
        get 'activities'
        response.should be_success
      end
      it "should be success for community member with update" do
        sign_in admin_user
        get 'activities', updated: {since: Time.now.to_s}
        response.should be_success
      end
    end
    describe "with bad user" do
      it "should be forbidden for anon" do
        get 'activities'
        response.should be_forbidden
      end
      it "should be forbidden for non-community member" do
        random_user = create(:user)
        sign_in random_user
        get 'activities'
        response.should be_forbidden
      end
    end
  end
  describe "GET 'clear_action_items'" do
    describe "with good user" do
      it "should be success for admin" do
        sign_in admin_user
        get 'clear_action_items'
        response.should redirect_to(subdomain_home_url)
      end
    end
    describe "with bad user" do
      it "should be forbidden for anon" do
        get 'clear_action_items'
        response.should redirect_to(new_user_session_url)
      end
      it "should be forbidden for non-community member" do
        random_user = create(:user)
        sign_in random_user
        get 'clear_action_items'
        response.should be_forbidden
      end
    end
  end
end
