require 'spec_helper'

describe "single_select_questions/edit.html.haml" do
  before(:each) do
    @single_select_question = assign(:single_select_question, stub_model(SingleSelectQuestion))
  end

  it "renders the edit single_select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => single_select_questions_path(@single_select_question), :method => "post" do
    end
  end
end
