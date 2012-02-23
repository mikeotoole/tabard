require 'spec_helper'

describe "artwork_uploads/edit" do
  before(:each) do
    @artwork_upload = assign(:artwork_upload, stub_model(ArtworkUpload,
      :email => "MyString",
      :attribution_name => "MyString",
      :attribution_url => "MyString",
      :artwork_image => "MyString"
    ))
  end

  it "renders the edit artwork_upload form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => artwork_uploads_path(@artwork_upload), :method => "post" do
      assert_select "input#artwork_upload_email", :name => "artwork_upload[email]"
      assert_select "input#artwork_upload_attribution_name", :name => "artwork_upload[attribution_name]"
      assert_select "input#artwork_upload_attribution_url", :name => "artwork_upload[attribution_url]"
      assert_select "input#artwork_upload_artwork_image", :name => "artwork_upload[artwork_image]"
    end
  end
end
