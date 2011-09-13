require 'spec_helper'

describe "submissions/show.html.haml" do
  before(:each) do
    @submission = assign(:submission, stub_model(Submission,
      :custom_form_id => 1,
      :user_profile_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
