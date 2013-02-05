require 'spec_helper'

describe Subdomains::CommunityInvitesController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'index'" do
    it "returns http success for someone with permissions" do
      sign_in admin
      get 'index'
      response.should be_success
    end
    it "fail for someone without permissions" do
      sign_in non_member
      get 'index'
      response.should be_forbidden
    end
  end

  describe "POST mass_create" do
    describe "for good user" do
      it "returns http success for someone with permissions" do
        sign_in admin
        post 'mass_create'
        response.should be_redirect
      end
    end
    it "fail for someone without permissions" do
      sign_in non_member
      post 'mass_create'
      response.should be_forbidden
    end
  end

  describe "GET autocomplete" do
    describe "for good user" do
      it "returns http success for someone with permissions" do
        sign_in admin
        get 'autocomplete'
        response.should be_success
      end
      it "should render blank for less than 2 letter terms" do
        sign_in admin
        get 'autocomplete', term: ""
        @json = {
          results: []
        }.to_json
        response.body.should == @json
      end
      it "should render blank for less than 2 letter terms" do
        sign_in admin
        admin.user_profile.update_column(:display_name, "THIS IS COOL")
        get 'autocomplete', term: "THIS IS COOL"
        @json = [{label: admin.display_name, value: admin.id, avatar: admin.avatar_url(:icon)}].to_json
        response.body.should == @json
      end
    end
    it "fail for someone without permissions" do
      sign_in non_member
      get 'autocomplete'
      response.should be_forbidden
    end
  end

  it "fail for someone without permissions" do
    sign_in non_member
    get 'index'
    response.should be_forbidden
  end
end
