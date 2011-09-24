require 'spec_helper'

describe "community_applications/show.html.haml" do
  before(:each) do
    @community_application = assign(:community_application, stub_model(CommunityApplication,
      :community_id => 1,
      :user_profile_id => 1,
      :submission_id => 1,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
  end
end
