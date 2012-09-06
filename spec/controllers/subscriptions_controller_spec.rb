require 'spec_helper'

describe SubscriptionsController do
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { admin.owned_communities.first }
  let(:plan) { create(:community_plan, title: "Pro", max_number_of_users: 100, price_per_month_in_cents: 10000) }
  let(:card_token) { DefaultObjects.stripe_card_token }
  let(:admin_with_stripe) { DefaultObjects.community_admin_with_stripe }
  let(:community_with_stripe) { admin_with_stripe.owned_communities.first }

  describe "GET index" do
    it "assigns all users owned_communities as @owned_communities when authenticated as a user" do
      sign_in admin
      get :index
      assigns(:owned_communities).should eq(admin.owned_communities)
    end

    it "should render the 'index' template when authenticated as a user" do
      sign_in admin
      get :index
      response.should render_template("index")
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "GET 'edit'" do
    it "should be successful when authenticated as an authorized user" do
      sign_in admin
      get 'edit', id: community
      response.should be_success
    end

    it "should render subscriptions/edit template when authenticated as an authorized user" do
      sign_in admin
      get 'edit', id: community
      response.should render_template('subscriptions/edit')
    end

    it "should assign only available plans to @available_plans" do
      create(:community_plan, is_available: false)

      sign_in admin
      get 'edit', id: community

      assigns[:available_plans].count.should_not eq 0
      assigns[:available_plans].each do |comm_plan|
        comm_plan.is_available.should be_true
      end
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', id: community
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      get 'edit', id: community
      response.should be_forbidden
    end
  end

  describe "PUT 'update'" do
    describe "when authenticated as a user with valid attributes and stripe token" do
      before(:each) do
        sign_in admin
        put 'update', id: community, community: { community_plan_id: plan.id }, stripe_card_token: card_token.id
      end

      it "should change plan" do
        Community.find(community).community_plan.should eq plan
      end

      it "should redirect back to subscription edit page" do
        response.should redirect_to(edit_subscription_url(community))
      end
    end

    it "should assign only available plans to @available_plans" do
      create(:community_plan, is_available: false)

      sign_in admin_with_stripe
      put 'update', id: community_with_stripe, community: { community_plan_id: plan.id }

      assigns[:available_plans].count.should_not eq 0
      assigns[:available_plans].each do |comm_plan|
        comm_plan.is_available.should be_true
      end
    end

    describe "when authenticated as a user with stripe customer token and valid attributes with no stripe token" do
      before(:each) do
        sign_in admin_with_stripe
        put 'update', id: community_with_stripe, community: { community_plan_id: plan.id }
      end

      it "should change plan" do
        Community.find(community_with_stripe).community_plan.should eq plan
      end
    end

    it "should require an attributes hash with a community plan" do
      sign_in admin_with_stripe
      put 'update', id: community_with_stripe
      response.should be_success
      assigns[:community].errors[:base].should include("You must pick a plan")
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      put 'update', id: community, community: { community_plan: plan }
      response.should be_forbidden
    end

    describe "when not authenticated as a user" do
      before(:each) do
        put 'update', id: community, community: { community_plan: plan }
      end

      it "should redirect to new user session path" do
        response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
      end

      it "should not change attributes" do
        assigns[:community].should be_nil
      end
    end
  end
end
