require 'spec_helper'

describe "multi_select_questions/show.html.haml" do
  before(:each) do
    @multi_select_question = assign(:multi_select_question, stub_model(MultiSelectQuestion))
  end

  it "renders attributes in <p>" do
    render
  end
end
