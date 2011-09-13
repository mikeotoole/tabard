require 'spec_helper'

describe "text_questions/show.html.haml" do
  before(:each) do
    @text_question = assign(:text_question, stub_model(TextQuestion))
  end

  it "renders attributes in <p>" do
    render
  end
end
