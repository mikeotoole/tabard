require 'spec_helper'

describe "submissions/edit.html.haml" do
  before(:each) do
    @submission = assign(:submission, stub_model(Submission,
      :custom_form_id => 1,
      :user_profile_id => 1
    ))
  end

  it "renders the edit submission form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => submissions_path(@submission), :method => "post" do
      assert_select "input#submission_custom_form_id", :name => "submission[custom_form_id]"
      assert_select "input#submission_user_profile_id", :name => "submission[user_profile_id]"
    end
  end
end
