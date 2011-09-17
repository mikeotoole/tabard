require 'spec_helper'

describe "roster_assignments/edit.html.haml" do
  before(:each) do
    @roster_assignment = assign(:roster_assignment, stub_model(RosterAssignment,
      :community_profile_id => 1,
      :character_proxy_id => 1,
      :pending => false
    ))
  end

  it "renders the edit roster_assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => roster_assignments_path(@roster_assignment), :method => "post" do
      assert_select "input#roster_assignment_community_profile_id", :name => "roster_assignment[community_profile_id]"
      assert_select "input#roster_assignment_character_proxy_id", :name => "roster_assignment[character_proxy_id]"
      assert_select "input#roster_assignment_pending", :name => "roster_assignment[pending]"
    end
  end
end
