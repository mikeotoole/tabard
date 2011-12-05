require 'spec_helper'

describe SwtorsController do

  describe "GET 'index'" do
    it "assigns all communities as @communities that have a swtor game" do
      DefaultObjects.community
      community = DefaultObjects.community_two
      get :index
      assigns(:communities).should eq([community])
    end
  end
end
