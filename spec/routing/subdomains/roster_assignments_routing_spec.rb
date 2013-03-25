require "spec_helper"

describe Subdomains::RosterAssignmentsController do
  describe "routing" do
    let(:roster_assignment) { create(:roster_assignment) }
    let(:community) { roster_assignment.community }

    it "routes #index to StatusCodeController#not_found" do
      { :get => "#{community.subdomain}.example.com/roster_assignments" }.should
        route_to(:controller => :status_code, :action => :not_found, :subdomain => 'www')
    end

    it "routes #show to StatusCodeController#not_found" do
      { :get => "#{community.subdomain}.example.com/roster_assignments/#{roster_assignment.id}" }.should
        route_to(:controller => :status_code, :action => :not_found, :subdomain => 'www')
    end

    it "routes #new to StatusCodeController#not_found" do
      { :get => "#{community.subdomain}.example.com/roster_assignments/new" }.should
        route_to(:controller => :status_code, :action => :not_found, :subdomain => 'www')
    end
  end
end
