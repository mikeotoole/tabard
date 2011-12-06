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

describe Subdomains::RosterAssignmentsController do
  let(:billy) { create(:billy) }
  let(:user_profile) { create(:user_profile) }
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:community_profile) { admin_user.community_profiles.first }
  let(:character_proxy) { create(:character_proxy_with_wow_character, :user_profile => admin_user.user_profile)}
  let(:character_proxy2) { create(:character_proxy_with_wow_character, :user_profile => admin_user.user_profile)}
  let(:roster_assignment) { create(:roster_assignment, :community_profile => community_profile, :character_proxy => character_proxy)}
  let(:roster_assignment2) { create(:roster_assignment, :community_profile => community_profile, :character_proxy => character_proxy2)}
  let(:roster_assignment_id_array) { [[roster_assignment.id], [roster_assignment2.id]] }
  let(:roster_assignment_att) { attributes_for(:roster_assignment, :community_profile => community_profile, :character_proxy => character_proxy) }

  before(:each) do
    community.update_attribute(:is_public_roster, false)
    @request.host = "#{community.subdomain}.example.com"
  end
  
  describe "GET 'index'" do
    it "should be unauthorized when authenticated as a non-member" do
      sign_in user
      get 'index'
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a member" do
      sign_in admin_user
      get 'index'
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'index'
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET 'show'" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get 'show', :id => roster_assignment
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get 'show', :id => roster_assignment
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get 'show', :id => roster_assignment
        assert_response :missing
      end
    end
  end

  describe "GET 'new'" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get 'new'
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get 'new'
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get 'new'
        assert_response :missing
      end
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non-owner" do
      sign_in user
      get 'edit', :id => roster_assignment
      response.response_code.should == 403
    end

    it "should be successful when authenticated as an owner" do
      sign_in admin_user
      get 'edit', :id => roster_assignment
      response.should be_success
    end

    it "shouldn't be successful when not authenticated as a user" do
      get 'edit', :id => roster_assignment
      response.should redirect_to(new_user_session_url)
    end

    it "should render roster_assignments/new template" do
      sign_in admin_user
      get 'edit', :id => roster_assignment
      response.should render_template('roster_assignments/edit')
    end
  end

  describe "POST 'create' authenticated as non-owner" do
    before(:each) do
      sign_in user
      post 'create', :roster_assignment => roster_assignment_att
    end
    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :roster_assignment => roster_assignment_att
    end

    it "should not create new record" do
      assigns[:roster_assignment].should be_nil
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "PUT 'update' when authenticated as a non-owner" do
    before(:each) do
      sign_in user
      put 'update', :id => roster_assignment, :roster_assignment => { :is_pending => false }
    end

    it "should change attributes" do
      assigns[:roster_assignment].should be_nil
    end

    it "should be unauthorize" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when authenticated as an owner" do
    before(:each) do
      sign_in admin_user
      put 'update', :id => roster_assignment, :roster_assignment => { :is_pending => false }
    end

    it "should change attributes" do
      assigns[:roster_assignment].is_pending.should be_false
    end

    it "should redirect to new community" do
      response.should redirect_to(roster_assignment_url(assigns[:roster_assignment]))
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      put 'update', :id => roster_assignment, :roster_assignment => { :is_pending => false }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "DELETE 'destroy'" do 
    before(:each) do
      @roster_assignment = create(:roster_assignment, :community_profile => community_profile, :character_proxy => character_proxy2)
    end
    it "should be successful when authenticated as an owner" do
      sign_in admin_user
      delete 'destroy', :id => @roster_assignment
      RosterAssignment.exists?(@roster_assignment).should be_false
      response.should redirect_to(my_roster_assignments_url)
    end
    it "should be unauthorized when authenticated as a non-owner" do
      sign_in user
      delete 'destroy', :id => @roster_assignment
      RosterAssignment.exists?(@roster_assignment).should be_true
      response.response_code.should == 403
    end
    it "should not be successful when not authenticated as a user" do
      delete 'destroy', :id => @roster_assignment
      RosterAssignment.exists?(@roster_assignment).should be_true
      response.should redirect_to(new_user_session_url)
    end
  end
  
  describe "PUT 'batch_destroy'" do
    it "should delete all roster assignments when authenticated as admin" do
      sign_in admin_user
      delete :batch_destroy, :ids => roster_assignment_id_array
      RosterAssignment.find_by_id(roster_assignment).should be_nil
      RosterAssignment.find_by_id(roster_assignment2).should be_nil
    end
  end

  describe "PUT 'approve' when authenticated as an owner" do
    before(:each) do
      sign_in admin_user
      roster_assignment.update_attribute(:is_pending, true)
      put 'approve', :id => roster_assignment
    end

    it "become approved" do
      assigns[:roster_assignment].is_pending.should be_false
    end

    it "should redirect to pending path" do
      response.should redirect_to(pending_roster_assignments_url)
    end
  end
  
  describe "PUT 'batch_approve'" do
    before(:each) do
      roster_assignment.update_attribute(:is_pending, true)
      roster_assignment2.update_attribute(:is_pending, true)
    end
    it "should mark all roster assignments as approved when authenticated as admin" do
      sign_in admin_user
      put :batch_approve, :ids => roster_assignment_id_array
      RosterAssignment.find_by_id(roster_assignment).is_pending.should be_false
      RosterAssignment.find_by_id(roster_assignment2).is_pending.should be_false
    end
    it "should be forbidden when authenticated as member" do
      sign_in billy
      put :batch_approve, :ids => roster_assignment_id_array
      response.should be_forbidden
    end
  end

  describe "PUT 'reject' when authenticated as an owner" do
    before(:each) do
      sign_in admin_user
      roster_assignment.update_attribute(:is_pending, true)
      put 'reject', :id => roster_assignment
    end

    it "should no longer exist" do
      RosterAssignment.exists?(roster_assignment).should be_false
    end

    it "should redirect to pending path" do
      response.should redirect_to(pending_roster_assignments_url)
    end
  end
  
  describe "PUT 'batch_reject'" do
    before(:each) do
      roster_assignment.update_attribute(:is_pending, true)
      roster_assignment2.update_attribute(:is_pending, true)
    end
    it "should mark all roster assignments as approved when authenticated as admin" do
      sign_in admin_user
      put :batch_reject, :ids => roster_assignment_id_array
      RosterAssignment.find_by_id(roster_assignment).should be_nil
      RosterAssignment.find_by_id(roster_assignment2).should be_nil
    end
    it "should be forbidden when authenticated as member" do
      sign_in billy
      put :batch_reject, :ids => roster_assignment_id_array
      response.should be_forbidden
    end
  end

  describe "GET 'pending'" do
    it "should be unauthorized when authenticated as a non-member" do
      sign_in user
      get 'pending'
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a member" do
      sign_in admin_user
      get 'pending'
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'pending'
      response.should redirect_to(new_user_session_url)
    end
  end

end
