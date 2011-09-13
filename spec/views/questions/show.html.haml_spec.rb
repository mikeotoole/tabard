require 'spec_helper'

describe "questions/show.html.haml" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :body => "MyText",
      :custom_form_id => 1,
      :type => "Type",
      :style => "Style"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Style/)
  end
end
