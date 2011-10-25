require 'spec_helper'

describe "documents/new.html.haml" do
  before(:each) do
    assign(:document, stub_model(Document,
      :type => "",
      :body => "MyText",
      :version => "MyString"
    ).as_new_record)
  end

  it "renders new document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => documents_path, :method => "post" do
      assert_select "input#document_type", :name => "document[type]"
      assert_select "textarea#document_body", :name => "document[body]"
      assert_select "input#document_version", :name => "document[version]"
    end
  end
end
