require 'spec_helper'

describe "artwork_uploads/index" do
  before(:each) do
    assign(:artwork_uploads, [
      stub_model(ArtworkUpload,
        :email => "Email",
        :attribution_name => "Attribution Name",
        :attribution_url => "Attribution Url",
        :artwork_image => "Artwork Image"
      ),
      stub_model(ArtworkUpload,
        :email => "Email",
        :attribution_name => "Attribution Name",
        :attribution_url => "Attribution Url",
        :artwork_image => "Artwork Image"
      )
    ])
  end

  it "renders a list of artwork_uploads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Attribution Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Attribution Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Artwork Image".to_s, :count => 2
  end
end
