require 'spec_helper'

describe "community_applications/new.html.haml" do
  before(:each) do
    assign(:community_application, stub_model(CommunityApplication,
      :community_id => 1,
      :user_profile_id => 1,
      :submission_id => 1,
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new community_application form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => community_applications_path, :method => "post" do
      assert_select "input#community_application_community_id", :name => "community_application[community_id]"
      assert_select "input#community_application_user_profile_id", :name => "community_application[user_profile_id]"
      assert_select "input#community_application_submission_id", :name => "community_application[submission_id]"
      assert_select "input#community_application_status", :name => "community_application[status]"
    end
  end
end
