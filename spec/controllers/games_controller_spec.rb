require 'spec_helper'

describe GamesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'autocomplete'" do
    it "returns http success" do
      get 'autocomplete'
      response.should be_success
    end
  end

end
