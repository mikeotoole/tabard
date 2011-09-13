require 'spec_helper'

describe "text_questions/index.html.haml" do
  before(:each) do
    assign(:text_questions, [
      stub_model(TextQuestion),
      stub_model(TextQuestion)
    ])
  end

  it "renders a list of text_questions" do
    render
  end
end
