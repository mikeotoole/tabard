require 'spec_helper'

describe "single_select_questions/new.html.haml" do
  before(:each) do
    assign(:single_select_question, stub_model(SingleSelectQuestion).as_new_record)
  end

  it "renders new single_select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => single_select_questions_path, :method => "post" do
    end
  end
end
