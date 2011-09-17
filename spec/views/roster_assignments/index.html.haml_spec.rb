require 'spec_helper'

describe "roster_assignments/index.html.haml" do
  before(:each) do
    assign(:roster_assignments, [
      stub_model(RosterAssignment,
        :community_profile_id => 1,
        :character_proxy_id => 1,
        :pending => false
      ),
      stub_model(RosterAssignment,
        :community_profile_id => 1,
        :character_proxy_id => 1,
        :pending => false
      )
    ])
  end

  it "renders a list of roster_assignments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
