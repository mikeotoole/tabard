require 'spec_helper'

describe "documents/index.html.haml" do
  before(:each) do
    assign(:documents, [
      stub_model(Document,
        :type => "Type",
        :body => "MyText",
        :version => "Version"
      ),
      stub_model(Document,
        :type => "Type",
        :body => "MyText",
        :version => "Version"
      )
    ])
  end

  it "renders a list of documents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
  end
end
