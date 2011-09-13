require 'spec_helper'

describe "predefined_answers/show.html.haml" do
  before(:each) do
    @predefined_answer = assign(:predefined_answer, stub_model(PredefinedAnswer))
  end

  it "renders attributes in <p>" do
    render
  end
end
