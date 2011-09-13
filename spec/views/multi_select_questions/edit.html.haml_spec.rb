require 'spec_helper'

describe "multi_select_questions/edit.html.haml" do
  before(:each) do
    @multi_select_question = assign(:multi_select_question, stub_model(MultiSelectQuestion))
  end

  it "renders the edit multi_select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => multi_select_questions_path(@multi_select_question), :method => "post" do
    end
  end
end
