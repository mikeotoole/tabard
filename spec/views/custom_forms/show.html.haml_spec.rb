require 'spec_helper'

describe "custom_forms/show.html.haml" do
  before(:each) do
    @custom_form = assign(:custom_form, stub_model(CustomForm,
      :name => "Name",
      :message => "MyText",
      :thankyou => "Thankyou",
      :community_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Thankyou/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
