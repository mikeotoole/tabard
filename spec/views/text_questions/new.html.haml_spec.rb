require 'spec_helper'

describe "text_questions/new.html.haml" do
  before(:each) do
    assign(:text_question, stub_model(TextQuestion).as_new_record)
  end

  it "renders new text_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => text_questions_path, :method => "post" do
    end
  end
end
