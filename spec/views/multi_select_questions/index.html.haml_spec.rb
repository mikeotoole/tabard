require 'spec_helper'

describe "multi_select_questions/index.html.haml" do
  before(:each) do
    assign(:multi_select_questions, [
      stub_model(MultiSelectQuestion),
      stub_model(MultiSelectQuestion)
    ])
  end

  it "renders a list of multi_select_questions" do
    render
  end
end
