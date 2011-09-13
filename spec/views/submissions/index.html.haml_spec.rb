require 'spec_helper'

describe "submissions/index.html.haml" do
  before(:each) do
    assign(:submissions, [
      stub_model(Submission,
        :custom_form_id => 1,
        :user_profile_id => 1
      ),
      stub_model(Submission,
        :custom_form_id => 1,
        :user_profile_id => 1
      )
    ])
  end

  it "renders a list of submissions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
