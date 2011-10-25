require 'spec_helper'

describe "documents/show.html.haml" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :type => "Type",
      :body => "MyText",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
  end
end
