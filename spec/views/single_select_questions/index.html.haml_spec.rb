require 'spec_helper'

describe "single_select_questions/index.html.haml" do
  before(:each) do
    assign(:single_select_questions, [
      stub_model(SingleSelectQuestion),
      stub_model(SingleSelectQuestion)
    ])
  end

  it "renders a list of single_select_questions" do
    render
  end
end
