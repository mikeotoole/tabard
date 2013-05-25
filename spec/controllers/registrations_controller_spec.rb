require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe RegistrationsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET disable_confirmation" do
    it "assigns the current_user as @user when authenticated as a user" do
      sign_in user
      get :disable_confirmation
      assigns(:user).should eq(user)
    end

    it "should render the 'cancel_confirmation' template when authenticated as a user" do
      sign_in user
      get :disable_confirmation
      response.should render_template("disable_confirmation")
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :disable_confirmation
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "DELETE destroy" do
    describe "when authenticated as owner" do
      before(:each) {
        sign_in user
      }

      it "marks user as is_user_disabled" do
        delete :destroy, :user => {:current_password => "Password"}
        response.should redirect_to(root_url)
        updated_user = User.find(user)
        updated_user.user_disabled_at.should_not be_nil
        updated_user.admin_disabled_at.should be_nil
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          delete :destroy, :user => {:current_password => "Not Pass"}
          assigns(:user).should eq(user)
        end

        it "re-renders the 'cancel_confirmation' template" do
          delete :destroy, :user => {:current_password => "Not Pass"}
          response.should render_template("disable_confirmation")
        end
      end

      it "should remove user from communities" do
        user.owned_communities.should be_empty
        community_profiles = user.community_profiles.all

        delete :destroy, :user => {:current_password => "Password"}

        community_profiles.should_not be_empty
        community_profiles.each do |c_profile|
          CommunityProfile.exists?(c_profile).should be_false
        end
      end

      it "should delete owned communities" do
        sign_in admin
        owned_communities = admin.owned_communities.all
        community_profiles = admin.community_profiles.all

        delete :destroy, :user => {:current_password => "Password"}

        owned_communities.should_not be_empty
        community_profiles.should_not be_empty
        community_profiles.each do |c_profile|
          CommunityProfile.exists?(c_profile).should be_false
        end
        owned_communities.each do |community|
          Community.exists?(community).should be_false
        end
      end

      it "redirects to the root_url when authenticated as owner" do
        delete :destroy, :user => {:current_password => "Password"}
        response.should redirect_to(root_url)
      end
    end

    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :user => {:current_password => "Password"}
      response.should redirect_to(new_user_session_url)
    end
  end
end
