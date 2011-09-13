require 'spec_helper'

describe "select_questions/index.html.haml" do
  before(:each) do
    assign(:select_questions, [
      stub_model(SelectQuestion),
      stub_model(SelectQuestion)
    ])
  end

  it "renders a list of select_questions" do
    render
  end
end
