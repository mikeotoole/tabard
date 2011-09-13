require 'spec_helper'

describe "predefined_answers/edit.html.haml" do
  before(:each) do
    @predefined_answer = assign(:predefined_answer, stub_model(PredefinedAnswer))
  end

  it "renders the edit predefined_answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => predefined_answers_path(@predefined_answer), :method => "post" do
    end
  end
end
