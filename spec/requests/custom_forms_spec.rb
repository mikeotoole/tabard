require 'spec_helper'

describe "CustomForms" do
  describe "GET /custom_forms" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get custom_forms_path
      response.status.should be(200)
    end
  end
end
