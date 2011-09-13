require 'spec_helper'

describe "select_questions/show.html.haml" do
  before(:each) do
    @select_question = assign(:select_question, stub_model(SelectQuestion))
  end

  it "renders attributes in <p>" do
    render
  end
end
