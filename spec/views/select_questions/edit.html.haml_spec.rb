require 'spec_helper'

describe "select_questions/edit.html.haml" do
  before(:each) do
    @select_question = assign(:select_question, stub_model(SelectQuestion))
  end

  it "renders the edit select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => select_questions_path(@select_question), :method => "post" do
    end
  end
end
