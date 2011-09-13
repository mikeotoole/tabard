require 'spec_helper'

describe "text_questions/edit.html.haml" do
  before(:each) do
    @text_question = assign(:text_question, stub_model(TextQuestion))
  end

  it "renders the edit text_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => text_questions_path(@text_question), :method => "post" do
    end
  end
end
