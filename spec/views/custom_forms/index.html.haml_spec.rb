require 'spec_helper'

describe "custom_forms/index.html.haml" do
  before(:each) do
    assign(:custom_forms, [
      stub_model(CustomForm,
        :name => "Name",
        :message => "MyText",
        :thankyou => "Thankyou",
        :community_id => 1
      ),
      stub_model(CustomForm,
        :name => "Name",
        :message => "MyText",
        :thankyou => "Thankyou",
        :community_id => 1
      )
    ])
  end

  it "renders a list of custom_forms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Thankyou".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
