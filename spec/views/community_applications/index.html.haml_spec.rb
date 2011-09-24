require 'spec_helper'

describe "community_applications/index.html.haml" do
  before(:each) do
    assign(:community_applications, [
      stub_model(CommunityApplication,
        :community_id => 1,
        :user_profile_id => 1,
        :submission_id => 1,
        :status => "Status"
      ),
      stub_model(CommunityApplication,
        :community_id => 1,
        :user_profile_id => 1,
        :submission_id => 1,
        :status => "Status"
      )
    ])
  end

  it "renders a list of community_applications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
