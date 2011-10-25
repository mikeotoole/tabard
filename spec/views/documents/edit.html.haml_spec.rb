require 'spec_helper'

describe "documents/edit.html.haml" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :type => "",
      :body => "MyText",
      :version => "MyString"
    ))
  end

  it "renders the edit document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => documents_path(@document), :method => "post" do
      assert_select "input#document_type", :name => "document[type]"
      assert_select "textarea#document_body", :name => "document[body]"
      assert_select "input#document_version", :name => "document[version]"
    end
  end
end
