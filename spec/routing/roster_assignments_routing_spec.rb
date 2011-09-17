require "spec_helper"

describe RosterAssignmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/roster_assignments").should route_to("roster_assignments#index")
    end

    it "routes to #new" do
      get("/roster_assignments/new").should route_to("roster_assignments#new")
    end

    it "routes to #show" do
      get("/roster_assignments/1").should route_to("roster_assignments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/roster_assignments/1/edit").should route_to("roster_assignments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/roster_assignments").should route_to("roster_assignments#create")
    end

    it "routes to #update" do
      put("/roster_assignments/1").should route_to("roster_assignments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/roster_assignments/1").should route_to("roster_assignments#destroy", :id => "1")
    end

  end
end
