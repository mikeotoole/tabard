require "spec_helper"

describe Subdomains::RosterAssignmentsController do
  describe "routing" do
    let(:roster_assignment) { create(:roster_assignment) }
    let(:community) { roster_assignment.community }
    
    it "routes #index to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/roster_assignments/#{roster_assignment.id}", 
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/roster_assignments/#{roster_assignment.id}"
    end
    
    it "routes #new to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/roster_assignments/new", 
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/roster_assignments/new"
    end
  end
end
