require 'spec_helper'

describe "artwork_uploads/show" do
  before(:each) do
    @artwork_upload = assign(:artwork_upload, stub_model(ArtworkUpload,
      :email => "Email",
      :attribution_name => "Attribution Name",
      :attribution_url => "Attribution Url",
      :artwork_image => "Artwork Image"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Attribution Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Attribution Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Artwork Image/)
  end
end
