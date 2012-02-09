require 'spec_helper'

describe SwtorsController do

  describe "GET 'index'" do
    it "assigns all communities as @communities that have a swtor game" do
      community = DefaultObjects.community
      get :index
      assigns(:communities).should eq([community])
    end
  end
end
