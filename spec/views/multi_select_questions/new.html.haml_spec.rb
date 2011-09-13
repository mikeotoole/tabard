require 'spec_helper'

describe "multi_select_questions/new.html.haml" do
  before(:each) do
    assign(:multi_select_question, stub_model(MultiSelectQuestion).as_new_record)
  end

  it "renders new multi_select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => multi_select_questions_path, :method => "post" do
    end
  end
end
