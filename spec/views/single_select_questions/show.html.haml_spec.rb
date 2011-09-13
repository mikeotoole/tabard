require 'spec_helper'

describe "single_select_questions/show.html.haml" do
  before(:each) do
    @single_select_question = assign(:single_select_question, stub_model(SingleSelectQuestion))
  end

  it "renders attributes in <p>" do
    render
  end
end
