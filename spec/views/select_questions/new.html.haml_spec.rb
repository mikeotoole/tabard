require 'spec_helper'

describe "select_questions/new.html.haml" do
  before(:each) do
    assign(:select_question, stub_model(SelectQuestion).as_new_record)
  end

  it "renders new select_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => select_questions_path, :method => "post" do
    end
  end
end
