require 'spec_helper'

describe "predefined_answers/new.html.haml" do
  before(:each) do
    assign(:predefined_answer, stub_model(PredefinedAnswer).as_new_record)
  end

  it "renders new predefined_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => predefined_answers_path, :method => "post" do
    end
  end
end
