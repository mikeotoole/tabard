require "spec_helper"

describe SelectQuestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/select_questions").should route_to("select_questions#index")
    end

    it "routes to #new" do
      get("/select_questions/new").should route_to("select_questions#new")
    end

    it "routes to #show" do
      get("/select_questions/1").should route_to("select_questions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/select_questions/1/edit").should route_to("select_questions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/select_questions").should route_to("select_questions#create")
    end

    it "routes to #update" do
      put("/select_questions/1").should route_to("select_questions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/select_questions/1").should route_to("select_questions#destroy", :id => "1")
    end

  end
end
