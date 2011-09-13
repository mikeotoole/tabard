require "spec_helper"

describe PredefinedAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/predefined_answers").should route_to("predefined_answers#index")
    end

    it "routes to #new" do
      get("/predefined_answers/new").should route_to("predefined_answers#new")
    end

    it "routes to #show" do
      get("/predefined_answers/1").should route_to("predefined_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/predefined_answers/1/edit").should route_to("predefined_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/predefined_answers").should route_to("predefined_answers#create")
    end

    it "routes to #update" do
      put("/predefined_answers/1").should route_to("predefined_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/predefined_answers/1").should route_to("predefined_answers#destroy", :id => "1")
    end

  end
end
