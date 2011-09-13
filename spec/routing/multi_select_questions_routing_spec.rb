require "spec_helper"

describe MultiSelectQuestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/multi_select_questions").should route_to("multi_select_questions#index")
    end

    it "routes to #new" do
      get("/multi_select_questions/new").should route_to("multi_select_questions#new")
    end

    it "routes to #show" do
      get("/multi_select_questions/1").should route_to("multi_select_questions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/multi_select_questions/1/edit").should route_to("multi_select_questions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/multi_select_questions").should route_to("multi_select_questions#create")
    end

    it "routes to #update" do
      put("/multi_select_questions/1").should route_to("multi_select_questions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/multi_select_questions/1").should route_to("multi_select_questions#destroy", :id => "1")
    end

  end
end
