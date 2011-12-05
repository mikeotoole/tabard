require 'spec_helper'

describe WowsController do

  describe "GET 'index'" do
    it "assigns all communities as @communities that have a wow game" do
      DefaultObjects.community_two
      community = DefaultObjects.community
      get :index
      assigns(:communities).should eq([community])
    end
  end
end
