require 'spec_helper'

describe Admin::AdminUsersController do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  
  describe "GET index" do
#    it "when signed in as superadmin is successful" do
#      sign_in superadmin
#      get :index
#      response.should redirect_to("/")
#    end
    
    it "when signed in as User redirects to /admin/login" do
      sign_in user
      get :index
      response.should redirect_to('/admin/login')
    end   
  end
end