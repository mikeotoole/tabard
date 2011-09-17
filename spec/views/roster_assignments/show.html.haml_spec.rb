require 'spec_helper'

describe "roster_assignments/show.html.haml" do
  before(:each) do
    @roster_assignment = assign(:roster_assignment, stub_model(RosterAssignment,
      :community_profile_id => 1,
      :character_proxy_id => 1,
      :pending => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
