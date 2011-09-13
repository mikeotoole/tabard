require 'spec_helper'

describe "predefined_answers/index.html.haml" do
  before(:each) do
    assign(:predefined_answers, [
      stub_model(PredefinedAnswer),
      stub_model(PredefinedAnswer)
    ])
  end

  it "renders a list of predefined_answers" do
    render
  end
end
