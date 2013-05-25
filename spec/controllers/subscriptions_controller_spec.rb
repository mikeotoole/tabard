require 'spec_helper'

describe SubscriptionsController do
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { admin.owned_communities.first }
  let(:plan) { create(:community_plan, title: "Pro", max_number_of_users: 100, price_per_month_in_cents: 10000) }
  let(:card_token) { DefaultObjects.stripe_card_token_out_state }
  let(:admin_with_stripe) { DefaultObjects.community_admin_with_stripe_out_state }
  let(:community_with_stripe) { admin_with_stripe.owned_communities.first }
  let(:pro_community) { create(:pro_community) }
  let(:pro_admin) { pro_community.admin_profile.user }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

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
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET 'edit'" do
    it "should be successful when authenticated as an authorized user" do
      sign_in admin
      get 'edit', community_id: community
      response.should be_success
    end

    it "should not allow a community the user does not own" do
      sign_in admin
      get 'edit', community_id: create(:community)
      response.should be_not_found
    end

    it "should redirect to subscritpions index if current invoice is processing_payment" do
      sign_in pro_admin
      pro_community.is_paid_community?.should be_true
      pro_admin.current_invoice.update_column(:processing_payment, true)
      get 'edit', community_id: pro_community
      response.should redirect_to(subscriptions_url)
    end

    it "should render subscriptions/edit template when authenticated as an authorized user" do
      sign_in admin
      get 'edit', community_id: community
      response.should render_template('subscriptions/edit')
    end

    it "should assign only available plans to @available_plans" do
      create(:community_plan, is_available: false)

      sign_in admin
      get 'edit', community_id: community

      assigns[:available_plans].count.should_not eq 0
      assigns[:available_plans].each do |comm_plan|
        comm_plan.is_available.should be_true
      end
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', community_id: community
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      get 'edit', community_id: community
      response.should be_not_found
    end
  end

  describe "PUT 'update'" do
    describe "when authenticated as a user with valid attributes and stripe token" do
      before(:each) do
        sign_in admin
        put 'update', community_id: community, stripe_card_token: card_token, invoice: {"invoice_items_attributes"=>
                                                                                                 {"0"=>{"community_id"=>"#{community.id}",
                                                                                                        "item_type"=>"CommunityPlan",
                                                                                                        "quantity"=>"1",
                                                                                                        "item_id"=>"#{plan.id}"} } }
      end

      it "should change plan" do
        Community.find(community).recurring_community_plan.should eq plan
      end

      it "should redirect back to subscription edit page" do
        response.should redirect_to(edit_subscription_url(community))
      end
    end

    it "should not allow a community the user does not own" do
      sign_in admin
      put 'update', community_id: create(:community), stripe_card_token: card_token, invoice: {"invoice_items_attributes"=>
                                                                                                 {"0"=>{"community_id"=>"#{community.id}",
                                                                                                        "item_type"=>"CommunityPlan",
                                                                                                        "quantity"=>"1",
                                                                                                        "item_id"=>"#{plan.id}"} } }
      response.should be_not_found
    end

    it "should redirect to subscritpions index if current invoice is processing_payment" do
      sign_in pro_admin
      pro_community.is_paid_community?.should be_true
      pro_admin.current_invoice.update_column(:processing_payment, true)
      put 'update', community_id: pro_community, stripe_card_token: card_token, invoice: {"invoice_items_attributes"=>
                                                                                                 {"0"=>{"community_id"=>"#{pro_community.id}",
                                                                                                        "item_type"=>"CommunityPlan",
                                                                                                        "quantity"=>"1",
                                                                                                        "item_id"=>"#{plan.id}"} } }
      response.should redirect_to(subscriptions_url)
    end

    it "should assign only available plans to @available_plans" do
      create(:community_plan, is_available: false)

      sign_in admin_with_stripe
      put 'update', community_id: community_with_stripe, invoice: {"invoice_items_attributes"=>{"0"=>{"community_id"=>"#{community_with_stripe.id}",
                                                                                                      "item_type"=>"CommunityPlan",
                                                                                                      "quantity"=>"1",
                                                                                                      "item_id"=>"#{plan.id}"} } }

      assigns[:available_plans].count.should_not eq 0
      assigns[:available_plans].each do |comm_plan|
        comm_plan.is_available.should be_true
      end
    end

    describe "when authenticated as a user with stripe customer token and valid attributes with no stripe token" do
      before(:each) do
        sign_in admin_with_stripe
        put 'update', community_id: community_with_stripe, invoice: {"invoice_items_attributes"=>{"0"=>{"community_id"=>"#{community_with_stripe.id}",
                                                                                                        "item_type"=>"CommunityPlan",
                                                                                                        "quantity"=>"1",
                                                                                                        "item_id"=>"#{plan.id}"} } }
      end

      it "should change plan" do
        Community.find(community_with_stripe).recurring_community_plan.should eq plan
      end
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      put 'update', community_id: community, invoice: {"invoice_items_attributes"=>{"0"=>{"community_id"=>"#{community.id}",
                                                                                          "item_type"=>"CommunityPlan",
                                                                                          "quantity"=>"1",
                                                                                          "item_id"=>"#{plan.id}"} } }
      response.should be_not_found
    end

    describe "when not authenticated as a user" do
      before(:each) do
        put 'update', community_id: community, invoice: {"invoice_items_attributes"=>{"0"=>{"community_id"=>"#{community.id}",
                                                                                            "item_type"=>"CommunityPlan",
                                                                                            "quantity"=>"1",
                                                                                            "item_id"=>"#{plan.id}"} } }
      end

      it "should redirect to new user session path" do
        response.should redirect_to(new_user_session_url)
      end

      it "should not change attributes" do
        assigns[:community].should be_nil
      end
    end
  end
end
